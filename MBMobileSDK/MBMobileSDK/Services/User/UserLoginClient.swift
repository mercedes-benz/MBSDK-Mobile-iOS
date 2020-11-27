//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import MBNetworkKit
import MBCommonKit

protocol UserLoginFunctions {
    
    /// Initiates the login flow by asking the BFF if the user exists and
    /// triggering the BFF to send the user a TAN code.
    ///
    /// - Parameters;
    ///     - username: The credential entered by the user, either mail or phone
    ///     - nonce: A random nonce to later correlate the login flow. Must
    ///         be stored by the caller.
    ///     - preferredAuthType: The preferred authentication type. In the end,
    ///         the BFF has the final say which auth type we have to use for further
    ///         requests (part of the callback result), but we can ask nicely for a
    ///         specific one. If the BFF does NOT answer with an auth type, the
    ///         preferred auth type will be returned.
    ///     - completion: completion handler.
    func initiateLogin(username: String,
                       nonce: String,
                       preferredAuthType: AuthenticationType,
                       completion: @escaping (Result<(UserExistModel, AuthenticationType), LoginServiceError>) -> Void)
}

class UserLoginClient: UserLoginFunctions {
    
    private let networking: Networking
    private let userFunctions: UserServiceRepresentable
    private let userRegionHelper: UserRegionHelping
    
    init(networking: Networking = NetworkService(),
         userFunctions: UserServiceRepresentable,
         userRegionHelper: UserRegionHelping = UserRegionHelper()) {
        self.networking = networking
        self.userFunctions = userFunctions
        self.userRegionHelper = userRegionHelper
    }
    
    func initiateLogin(username: String, nonce: String, preferredAuthType: AuthenticationType, completion: @escaping (Result<(UserExistModel, AuthenticationType), LoginServiceError>) -> Void) {
        
        guard let json = self.loginUserJson(username: username, nonce: nonce) else {
            LOG.E("could not create requestDoesUserExist json payload for username: \(username)")
            completion(.failure(.unknown))
            return
        }
        
        // bff /login
        let router = BffUserRouter.exist(payload: json, authType: preferredAuthType)

        self.networking.request(router: router) { [weak self] (result: Result<(value: APIUserExistModel, headers: [AnyHashable: Any]), MBError>) in
            
            switch result {
            case .success((let apiUserExist, let headers)):
                
                let authResponse = self?.authResponseHeaderValue(headers) ?? preferredAuthType
                let userExistModel = NetworkModelMapper.map(apiUserExist: apiUserExist)
                
                guard userExistModel.username.isEmpty == false else {
                    LOG.I("No user found for the username: \(username)")
                    completion(.failure(.userNotFound(userExistModel, authResponse)))
                    return
                }
                
                LOG.D("Found a user: \(userExistModel)")
                completion(.success((userExistModel, authResponse)))
            
            case .failure(let error):
                LOG.E("Checking if user exists did fail with error: \(error)")
                completion(.failure(.initiateLoginDidFail(error)))
            }
        }
    }
    
    
    /// Evaluate the HTTP reponse headers and set the authentication type
    /// if a X-AuthMode is present and valid
    private func authResponseHeaderValue(_ headers: [AnyHashable: Any]) -> AuthenticationType? {
        
        guard let key = IngressKit.bffProvider?.headerParamProvider.authorizationModeParamKey else {
            LOG.E("Trying to evaluate backend auth mode, but IngressKit.bffProvider is nil.")
            return nil
        }
        
        guard let authModeHeaderValue = headers[key] as? String else {
            LOG.E("Trying to evaluate backend auth mode, but no header with the authorizationModeParamKey was present. \nauthorizationModeParamKey: \(key)\nheaders: \(headers)")
            return nil
        }
        
        LOG.D("BFF responded with auth mode: \(authModeHeaderValue)")
        return AuthenticationType(rawValue: authModeHeaderValue)
    }
    
    private func loginUserJson(username: String, nonce: String) -> [String: Any]? {
        let loginUser = LoginUserModel(
            countryCode: self.userRegionHelper.countryCode(for: userFunctions.currentUser),
            emailOrPhoneNumber: username,
            locale: self.userRegionHelper.locale(for: userFunctions.currentUser),
            nonce: nonce)
        
        LOG.V("Trying to create loginUserJson for userModel: \(loginUser)")
        return try? loginUser.toJson() as? [String: Any]
    }
}
