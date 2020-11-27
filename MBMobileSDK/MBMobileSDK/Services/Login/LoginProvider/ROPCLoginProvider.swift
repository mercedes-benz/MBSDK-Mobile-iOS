//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit
import MBCommonKit

class ROPCLoginProvider: LoginProvider {
    
    var type: AuthenticationType {
        return self.config.type
    }

    private enum TokenRefreshState {
        case unauthorized
        case tokenExpired(String)
        case refreshTokenUnavailable
        case noRefreshRequired(Token)
    }
    
    private static let wrongPinErrorKey = "invalid_grant"
    
	// MARK: Typealias
    
    internal typealias LoginAPIResult = NetworkResult<APILoginModel>
	
	// MARK: Properties
	
	public var token: Token? {
        return tokenStore.get()
    }
	
    private let tokenStore: TokenStore
    private let networkService: Networking
    private let config: ROPCAuthenticationProviding
    
    private var refreshTokenHandlers = [TokenResult]()
    
	// MARK: - Init
	
    init(config: ROPCAuthenticationProviding,
         tokenStore: TokenStore = KeychainTokenStoreFactory().build(),
         networkService: Networking = NetworkService()) {
        self.config = config
        self.tokenStore = tokenStore
        self.networkService = networkService
    }
    
    // MARK: - LoginProvider
    func login(username: String, credential: String, completion: @escaping (Result<Void, LoginServiceError>) -> Void) {

        LOG.D("Starting login request - username: \(username), credential: \(credential), type: \(self.type)")
        let router = ROPCEndpointRouter.login(provider: config, username: username, credential: credential)
        self.request(router: router, errorType: APIErrorROPCModel.self) { [weak self] (result) in
            
            switch result {
            case .failure(let error):
                // in any case of failure, be save and nil the token if one was there
                _ = self?.tokenStore.save(nil)
                
                if error.localizedDescription?.contains(ROPCLoginProvider.wrongPinErrorKey) ?? false {
                    LOG.D("Login request did fail because the given pin was invalid.")
                    completion(.failure(.loginDidFailWithInvalidPin))
                } else {
                    LOG.D("Login request did fail: \(error)")
                    completion(.failure(.loginDidFail(error)))
                }
                
            case .success(let token):
                let saveSuccess = self?.tokenStore.save(token)

                guard saveSuccess == true else {
                    LOG.E("Login was successful, but token could not be saved to the keychain.")
                    completion(.failure(.loginDidFail(nil)))
                    return
                }

                LOG.D("Login was successful with token: \(token)")
                
                completion(.success(()))
            }
        }
    }

    func logout(completion: @escaping (Result<Void, LoginServiceError>) -> Void) {
        
        LOG.D("Will start logout request")
        
        guard let token = self.token else {
            LOG.E("Trying to logout, but no token is available.")
            completion(.failure(.logoutDidFail(nil)))
            return
        }
        
        let router = ROPCEndpointRouter.logout(provider: config, token: token.refreshToken)
        
        self.requestLogout(router: router) { [weak self] (result) in
            _ = self?.tokenStore.save(nil)
            completion(result)
        }
    }
    
    func refreshTokenIfNeeded(completion: @escaping TokenResult) {

        switch self.assessTokenRefreshState(token: self.token) {
        case .noRefreshRequired(let token):
            completion(.success(token))
            
        case .refreshTokenUnavailable:
            let error = MBError(description: nil, type: .specificError(LoginError.emptyRefreshToken))
            completion(.failure(error))
            
        case .unauthorized:
            let error = MBError(description: nil, type: .specificError(LoginError.notAuthorized))
            completion(.failure(error))
            
        case .tokenExpired(let refreshToken):
            self.queueTokenRefresh(refreshToken: refreshToken, completion: completion)
        }
    }
    
	// MARK: - private methods
	
	private func requestLogout(router: ROPCEndpointRouter, completion: @escaping (Result<Void, LoginServiceError>) -> Void) {
		
        self.networkService.request(router: router) { (response: Result<Data, MBError>) in
            
			switch response {
			case .failure(let error):
                LOG.E("logout request did fail with error: \(String(describing: error.localizedDescription))")
                completion(.failure(.logoutDidFail(error)))
				
			case .success:
                LOG.D("Logout request was successful")
				completion(.success(()))
			}
		}
	}
    
	private func request<T: MBErrorConformable>(
        router: ROPCEndpointRouter,
        errorType: T.Type,
        completion: @escaping (Result<Token, MBError>) -> Void) {
        
        self.networkService.request(router: router, errorType: errorType) { (result: Result<APILoginModel, MBError>) in
            
            switch result {
            case .failure(let error):
                LOG.E(router)
                LOG.E(error.localizedDescription)
                completion(.failure(error))
                
            case .success(let value):
                LOG.D(value)
                completion(.success(NetworkModelMapper.map(apiLogin: value, authenticationType: self.type)))
            }
        }
	}
    
    private func doesTokenRequireRefresh(token: Token) -> Bool {
        // require token refresh a little bit earlier then the real expiration date
        let tokenExpirationPadding: TimeInterval = -60
        let expiredAt = token.expirationDate.addingTimeInterval(tokenExpirationPadding)
        
        return Date().compare(expiredAt) != .orderedAscending
    }

    private func assessTokenRefreshState(token: Token?) -> TokenRefreshState {
        guard let token = self.token else {
            return .unauthorized
        }
        
        if self.doesTokenRequireRefresh(token: token) {
            if token.refreshToken.isEmpty {
                return .refreshTokenUnavailable
            } else {
                return .tokenExpired(token.refreshToken)
            }
        } else {
            return .noRefreshRequired(token)
        }
    }
    
    private func performTokenRefresh(refreshToken: String, onCompletion: @escaping (Result<Token, MBError>) -> Void) {
    
        let router = ROPCEndpointRouter.refresh(provider: config, token: refreshToken)
        LOG.D("start token request with: \(refreshToken)")
        
        self.request(router: router, errorType: APIError.self) { [weak self] (result) in
            
            switch result {
            case .failure(let error):
                LOG.E("Refresh token request failed \(error)")
                onCompletion(.failure(error))
                
            case .success(let token):
                if let success = self?.tokenStore.save(token), success == true {
                    LOG.V("Token refresh was successful: \(token)")
                    onCompletion(.success(token))
                } else {
                    LOG.E("Refresh token request succeeded, but save the JWT failed")
                    onCompletion(.failure(MBError(description: "can not save token to store", type: .unknown)))
                }
            }
        }
    }
    
    private func queueTokenRefresh(refreshToken: String, completion: @escaping TokenResult) {
        
        self.refreshTokenHandlers.append(completion)
        
        // only perform a token fetch for the first requester
        if self.refreshTokenHandlers.count == 1 {
            self.performTokenRefresh(refreshToken: refreshToken) { [weak self] result in
                while let handler = self?.refreshTokenHandlers.popLast() {
                    handler(result)
                }
            }
        }
    }
}
