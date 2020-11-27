//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

import MBCommonKit
@testable import MBMobileSDK

class TokenTestHelper {
    
    static var token: Token {
        Token(accessToken: "aToken",
              tokenType: .keycloak,
              expirationDate: Date.distantFuture,
              refreshToken: "aRefreshToken",
              authenticationType: .keycloak)
    }
    
    static func token(accessToken: String = "aToken", expirationDate: Date = Date.distantFuture, refreshToken: String = "aRefreshToken", authenticationType: AuthenticationType = .keycloak) -> Token {
        Token(accessToken: accessToken,
              tokenType: .keycloak,
              expirationDate: expirationDate,
              refreshToken: refreshToken,
              authenticationType: authenticationType)
    }
    
}
