//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import MBCommonKit

/// TokenExchanging implementation that is specifically used to migrate
/// between an existing Keycloak token and a CIAM token
public class CIAMTokenExchangeService: TokenExchanging {
    
    // Dependencies
    private let loginService: LoginServiceRepresentable
    private let userService: UserServiceRepresentable
    private let loginProviderFactory: LoginProviderBuilding
    private let tokenStore: TokenStore
    
    // MARK: - Lifecycle
    public convenience init() {
        self.init(loginService: IngressKit.loginService,
                  userService: UserService(),
                  loginProviderFactory: LoginProviderFactory(),
                  tokenStore: KeychainTokenStoreFactory().build())
    }
    
    init(loginService: LoginServiceRepresentable,
         userService: UserServiceRepresentable,
         loginProviderFactory: LoginProviderBuilding,
         tokenStore: TokenStore) {
        self.loginService = loginService
        self.userService = userService
        self.loginProviderFactory = loginProviderFactory
        self.tokenStore = tokenStore
    }
    
    // MARK: - Public
    public func isTokenExchangePossible() -> Bool {
        return self.loginService.tokenState == .loggedIn &&
               self.loginService.token?.authenticationType == .keycloak &&
               self.getCiamAuthConfig() != nil
    }
    
    public func performTokenExchange(completion: @escaping (Result<Void, TokenExchangeError>) -> Void) {
        LOG.I("Starting token exchange...")
        
        guard let ciamConfig = self.getCiamAuthConfig() else {
            LOG.E("Token Exchange failed because no valid ciam auth config is available.")
            completion(.failure(.noValidAuthConfigAvailable))
            return
        }
        
        guard let loginProvider: LoginProvider = self.loginProviderFactory.buildProviders(
                authenticationProviders: [ciamConfig],
                tokenStore: self.tokenStore).first else {
         
            LOG.E("Unable to build a loginProvider based on the given config.")
            completion(.failure(.noValidAuthConfigAvailable))
            return
        }
        
        guard let tokenValue = self.loginService.token?.accessToken else {
            LOG.E("Token Exchange failed because there is no valid keycloak token to exchange")
            completion(.failure(.currentTokenNotAvailable))
            return
        }
        
        guard let username = self.userService.currentUser?.authenticationIdentifier else {
            LOG.E("Token Exchange failed because the user has no valid authentication identifier. user: \(String(describing: self.userService.currentUser))")
            completion(.failure(.invalidUserAuthenticationIdentifier))
            return
        }

        self.performLogin(loginProvider: loginProvider,
                          username: username,
                          credential: tokenValue,
                          completion: completion)
    }
    
    // MARK: - Private
    private func performLogin(loginProvider: LoginProvider,
                              username: String,
                              credential: String,
                              completion: @escaping (Result<Void, TokenExchangeError>) -> Void) {

        loginProvider.login(username: username, credential: credential) { result in
            switch result {
            case .success:
                LOG.I("Token exchange was performed successfully, new token: \(String(describing: self.loginService.token))")
                completion(.success(()))
                
            case .failure(let error):
                LOG.E("Token exchange failed with error: \(error)")
                completion(.failure(.tokenExchangeFailed))
            }
        }
    }
    
    private func getCiamAuthConfig() -> ROPCAuthenticationProviding? {
        return IngressKit.filteredAuthenticationProviders.first { $0.type == .ciam } as? ROPCAuthenticationProviding
    }
}
