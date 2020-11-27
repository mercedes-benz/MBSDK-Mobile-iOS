//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBNetworkKit
import MBCommonKit

public class LoginService: LoginServiceRepresentable {

    public var authenticationType: AuthenticationType? {
        return self.activeLoginProvider?.type
    }
    
    public var token: Token? {
        return self.tokenStore.get()
    }

	public var tokenState: TokenState {
        return self.state(of: self.token)
	}

    // Dependencies
    private let userFunctions: UserServiceRepresentable
    private let userLoginFunctions: UserLoginFunctions
    private let dbStore: UserDbStoreRepresentable
    private let loginBuilder: LoginProviderBuilding
    private let nonceHelper: NonceHelping
    private let nonceStore: NonceRepository
    private let tokenStore: TokenStore
    private let activeLoginProviderFilter: ActiveLoginProviderFiltering
    
    // state
    private var loginProviders: [LoginProvider]
    private var activeLoginProvider: LoginProvider? {
        self.activeLoginProviderFilter.activeLoginProvider(
            loginProviders: loginProviders,
            preferredAuthenticationType: IngressKit.preferredAuthenticationType)
    }
    
    public convenience init(authenticationProviders: [AuthenticationProviding] = IngressKit.filteredAuthenticationProviders, userFunctions: UserServiceRepresentable) {
        
        let tokenStore = KeychainTokenStoreFactory().build()

        self.init(authenticationProviders: authenticationProviders,
                  loginBuilder: LoginProviderFactory(),
                  dbStore: UserDbStore(),
                  userFunctions: userFunctions,
                  userLoginFunctions: UserLoginClient(userFunctions: userFunctions),
                  nonceHelper: NonceHelper(),
                  tokenStore: tokenStore,
                  nonceStore: NonceStore(),
                  activeLoginProviderFilter: ActiveLoginProviderFilter(tokenStore: tokenStore))
    }
    
    init(authenticationProviders: [AuthenticationProviding],
         loginBuilder: LoginProviderBuilding,
         dbStore: UserDbStoreRepresentable,
         userFunctions: UserServiceRepresentable,
         userLoginFunctions: UserLoginFunctions,
         nonceHelper: NonceHelping,
         tokenStore: TokenStore,
         nonceStore: NonceRepository,
         activeLoginProviderFilter: ActiveLoginProviderFiltering) {
        
        self.loginBuilder = loginBuilder
        self.tokenStore = tokenStore
        self.dbStore = dbStore
        self.userFunctions = userFunctions
        self.userLoginFunctions = userLoginFunctions
        self.nonceHelper = nonceHelper
        self.nonceStore = nonceStore
        self.loginProviders = loginBuilder.buildProviders(authenticationProviders: authenticationProviders, tokenStore: tokenStore)
        self.activeLoginProviderFilter = activeLoginProviderFilter
    }


	// MARK: - Public
    
    public func doesUserExist(username: String, completion: @escaping (Result<UserExistModel, LoginServiceError>) -> Void) {
        self.refreshProviders()
        
        LOG.D("Start doesUserExist check with preferredAuthType: \(String(describing: IngressKit.preferredAuthenticationType)), username: \(username)")

        let nonce = self.nonceHelper.getNonce()
        self.nonceStore.save(nonce: nonce) // remember nonce for token requests later
        
        self.userLoginFunctions.initiateLogin(username: username, nonce: nonce, preferredAuthType: IngressKit.preferredAuthenticationType) { result in
            
            switch result {
            case .success((let userExistModel, let authType)):
                LOG.D("Received new auth type from bff: \(authType.rawValue)")
                self.activeLoginProviderFilter.update(bffResponseAuthType: authType)
                completion(.success(userExistModel))
                
            case .failure(let error):
                LOG.E("User exists failed: \(error.localizedDescription)")
                switch error {
                case .userNotFound(_, let authType):
                    // user not found is a valid case where flow will continue with registration instead of login
                    // we need to save authType response from bff as well
                    LOG.D("Received new auth type from bff: \(authType.rawValue)")
                    self.activeLoginProviderFilter.update(bffResponseAuthType: authType)
                default:
                    break
                }
                completion(.failure(error))
            }
        }
    }
    
    public func login(username: String, pin: String, completion: @escaping (Result<UserModel, LoginServiceError>) -> Void) {
        LOG.D("Start login with provider: \(String(describing: self.activeLoginProvider?.type.rawValue)), username: \(username), pin: \(String(describing: pin))")
        
        guard let loginProvider = self.activeLoginProvider else {
            LOG.E("Trying to login without valid activeLoginProvider")
            completion(.failure(noValidProviderError()))
            return
        }
        
        guard let nonce = self.nonceStore.nonce() else {
            LOG.E("Trying to login at provider but nonce is nil")
            completion(.failure(.loginDidFail(nil)))
            return
        }
        
        guard pin.isEmpty == false else {
            LOG.E("Trying to login at provider but pin is empty")
            completion(.failure(.loginWithoutRequiredPin(pin)))
            return
        }
        
        loginProvider.login(username: username, credential: self.credential(for: loginProvider.type, pin: pin, nonce: nonce)) { [weak self] result in
            
            switch result {
            case .success:
                LOG.V("Succcessfully logged in user; Fetching user data...")
                self?.fetchUser(completion: completion)
                
            case .failure(let error):
                LOG.E("Login request did fail with error: \(error)")
                completion(.failure(error))
            }
        }
	}
    
    public func logout(completion: @escaping (Result<Void, LoginServiceError>) -> Void) {
        LOG.V("Start logout with \(String(describing: self.authenticationType))")
        
        guard let loginProvider = self.activeLoginProvider else {
            LOG.E("Trying to login without valid activeLoginProvider")
            completion(.failure(noValidProviderError()))
            return
        }
        
		loginProvider.logout { [weak self] (result) in
            
            switch result {
            case .success:
                
                self?.dbStore.deleteCurrentUser(completion: { result in
                    switch result {
                    case .failure(let error):
                        LOG.E("Removing user from store failed: \(error)")
                        completion(.failure(.logoutDeleteUserFromDB))
                    case .success:
                        LOG.D("Successfully removed user from store.")
                        // forget the bffResponseAuthType after logout so we start fresh for the next login
                        self?.activeLoginProviderFilter.update(bffResponseAuthType: nil)
                        completion(.success(()))
                    }
                })
            case .failure(let error):
                LOG.E("Logout did fail with error: \(error)")
                completion(.failure(error))
            }
		}
	}
	
    public func refreshTokenIfNeeded(completion: @escaping (Result<Token, MBError>) -> Void) {
        // this method is called very very often. Be careful with logging to not spam the log files.
        
        self.activeLoginProvider?.refreshTokenIfNeeded { result in
            
            switch result {
            case .success(let token):
                completion(.success(token))
                
            case .failure(let error):
                LOG.E("Refreshing token did fail with error: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Private
    // MARK: Helpers
    
    private func refreshProviders() {
        loginProviders = loginBuilder.buildProviders(authenticationProviders: IngressKit.filteredAuthenticationProviders, tokenStore: self.tokenStore)
    }
    
    private func credential(for authType: AuthenticationType, pin: String, nonce: String) -> String {
        
        switch authType {
        case .ciam:     return "\(nonce):\(pin)"
        case .keycloak: return "\(pin)"
        }
    }
    
    private func noValidProviderError() -> LoginServiceError {
        let providerTypes = self.loginProviders.map { $0.type }
        return .noValidLoginProviderAvailable(self.authenticationType, providerTypes)
    }
    
    private func fetchUser(completion: @escaping (Result<UserModel, LoginServiceError>) -> Void) {
        
        self.userFunctions.fetch { fetchUserResult in
            
            switch fetchUserResult {
            case .success(let user):
                LOG.V("Login was successful with user: \(user)")
                completion(.success(user))
                
            case .failure(let fetchUserError):
                LOG.E("Login did fail with error: \(fetchUserError)")
                completion(.failure(.fetchUserError(fetchUserError)))
            }
        }
    }
    
    private func state(of token: Token?) -> TokenState {
        guard let token = token else {
            return .loggedOut
        }
        
        return token.isAuthorized ? .loggedIn : .loggedOut
    }

}
