//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

@testable import MBMobileSDK
import MBCommonKit
import MBNetworkKit

class MockLoginProvider: LoginProvider, Equatable {
    
    // protocol properties
    var type: AuthenticationType
    var token: Token?
    
    // test support properties
    var onLogin: ((String, String) -> (success: Bool, error: LoginServiceError?))?
    var onLogout: (() -> (success: Bool, error: LoginServiceError?))?
    var onRefreshToken: (() -> (token: Token?, error: MBError?))?
    
    init(type: AuthenticationType = .keycloak) {
        self.type = type
    }
    
    func login(username: String, credential: String, completion: @escaping (Result<Void, LoginServiceError>) -> Void) {
        let mockResult = onLogin?(username, credential)
        if mockResult?.success == true {
            completion(.success(()))
        } else {
            completion(.failure((mockResult?.error ?? LoginServiceError.unknown)))
        }
    }
    
    func logout(completion: @escaping (Result<Void, LoginServiceError>) -> Void) {
        let logoutResult = onLogout?()
        if logoutResult?.success == true {
            completion(.success(()))
        } else {
            completion(.failure((logoutResult?.error)!))
        }
    }
    
    func refreshTokenIfNeeded(completion: @escaping TokenResult) {
        let tokenResult = onRefreshToken?()
        if let token = tokenResult?.token {
            completion(.success(token))
        } else {
            completion(.failure((tokenResult?.error)!))
        }
    }
    
    static func == (lhs: MockLoginProvider, rhs: MockLoginProvider) -> Bool {
        return  lhs.type == rhs.type &&
                lhs.token == rhs.token
    }
}
