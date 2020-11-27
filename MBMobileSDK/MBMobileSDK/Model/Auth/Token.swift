//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit

/// Representation of abstract layer of the jwt
public struct Token: Codable, Equatable, TokenConformable {
	
    // from token response
	public let accessToken: String
    public let tokenType: TokenType
    public let expirationDate: Date
    internal let refreshToken: String
    
    // set during mapping
    public private(set) var authenticationType: AuthenticationType? = .keycloak

    init(accessToken: String, tokenType: TokenType, expirationDate: Date, refreshToken: String, authenticationType: AuthenticationType) {
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.expirationDate = expirationDate
        self.refreshToken = refreshToken
        self.authenticationType = authenticationType
    }
    
    var isAccessTokenExpired: Bool {
        return expirationDate < Date()
    }
    
    var isAuthorized: Bool {
        return self.accessToken.isEmpty == false
    }
}
