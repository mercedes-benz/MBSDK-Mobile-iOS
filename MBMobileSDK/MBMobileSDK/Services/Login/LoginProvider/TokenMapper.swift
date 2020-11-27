//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit

protocol TokenMappable {
    func map(from apiLoginModel: APILoginModel, authenticationType: AuthenticationType) -> Token
}

class TokenMapper: TokenMappable {

    func map(from apiLoginModel: APILoginModel, authenticationType: AuthenticationType) -> Token {

        return Token(accessToken: apiLoginModel.accessToken,
                     tokenType: TokenType(rawValue: apiLoginModel.tokenType) ?? .keycloak,
                     expirationDate: Date(timeIntervalSinceNow: TimeInterval(apiLoginModel.expiresIn)),
                     refreshToken: apiLoginModel.refreshToken,
                     authenticationType: authenticationType)
    }
}
