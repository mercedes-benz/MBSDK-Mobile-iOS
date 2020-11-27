//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit
import MBCommonKit

/// Authentication functionality such as login, logout or refreshing tokens
public protocol LoginServiceRepresentable {

    /// Returns the currently active authentication type.
    /// The BFF back-end is deciding which authentication to use - even if we request
    /// e.g. keycloak, it may decide to use ciam for the specific app/user/region.
    var authenticationType: AuthenticationType? { get }
    
    /// Get current token-object (optional)
    var token: Token? { get }
    
    /// Get the state of the current token
    var tokenState: TokenState { get }

    /// Check if a user for the given username does already exist.
    ///
    /// In case of some authentication providers this may trigger out-of-app workflows,
    /// e.g. in case of Keycloak authentication a pin code is send to the user via email or sms.
    ///
    /// - Parameters:
    ///   - username: email or phonenumber
    ///   - completion: Result indicates if the user does already exist on the backend
    func doesUserExist(username: String, completion: @escaping (Result<UserExistModel, LoginServiceError>) -> Void)
    
    /// Start login request with user credentials
    ///
    /// - Parameters:
    ///   - username: email or phonenumber
    ///   - pin: pin from verification mail/sms
    ///   - completion: Result with the success or failure of the login call. Success returns the current user.
    func login(username: String, pin: String, completion: @escaping (Result<UserModel, LoginServiceError>) -> Void)
    
    /// Logout the user
    ///
    /// - Parameters:
    ///     - completion: Result with the success or failure of the logout call
    func logout(completion: @escaping (Result<Void, LoginServiceError>) -> Void)
    
    /// Returns the auth Token for the user, either from cache or by refreshing the Token
    ///
    /// - Parameters:
    ///   - completion: Result that contains either the refreshed Token or an Error
    func refreshTokenIfNeeded(completion: @escaping (Result<Token, MBError>) -> Void)
}

// Default implementations to make it easier to create mock objects by Apps
public extension LoginServiceRepresentable {
    func doesUserExist(username: String, completion: @escaping (Result<UserExistModel, LoginServiceError>) -> Void) {}
    func login(username: String, pin: String, completion: @escaping (Result<UserModel, LoginServiceError>) -> Void) {}
    func logout(completion: @escaping (Result<Void, LoginServiceError>) -> Void) {}
    func refreshTokenIfNeeded(completion: @escaping (Result<Token, MBError>) -> Void) {}
}
