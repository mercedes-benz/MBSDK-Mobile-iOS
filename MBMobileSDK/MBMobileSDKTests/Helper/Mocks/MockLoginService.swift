//
//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

import MBNetworkKit
import MBCommonKit
@testable import MBMobileSDK

public class MockLoginService: LoginServiceRepresentable {
    
    public var token: Token? = nil
    public var tokenState: TokenState = .loggedIn
    public var authenticationType: AuthenticationType? = .keycloak
    
    var onTokenRefresh: (() -> (token: String?, error: MBError?))?
    
    public func refreshTokenIfNeeded(completion: @escaping (Result<Token, MBError>) -> Void) {
        guard let refreshTuple = onTokenRefresh?() else {
            completion(.failure(.init(description: "error", type: .unknown)))
            return
        }
        
        if let token = refreshTuple.token {
            completion(.success(Token(accessToken: token,
                                      tokenType: .keycloak,
                                      expirationDate: Date.distantFuture,
                                      refreshToken: "aRefreshToken",
                                      authenticationType: .keycloak)))
        } else {
            completion(.failure(refreshTuple.error!))
        }
        
    }
}
