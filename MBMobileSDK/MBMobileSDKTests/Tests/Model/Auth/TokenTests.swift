//
//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Quick
import Nimble

import MBNetworkKit
import MBCommonKit
import MBRealmKit

@testable import MBMobileSDK

class TokenTests: QuickSpec {

    override func spec() {
        
        describe("isAccessTokenExpired") {
            it("should return true if the expiration date is in the past") {
                let token = self.token(withExpirationDate: Date.distantPast)
                expect(token.isAccessTokenExpired) == true
            }
            
            it("should return false if the expiration date is in the future") {
                let token = self.token(withExpirationDate: Date.distantFuture)
                expect(token.isAccessTokenExpired) == false
            }
        }
        
        describe("isAuthorized") {
            it("should return true if the access token is not empty") {
                let token = self.token()
                expect(token.isAuthorized) == true
            }
            
            it("should return false if the access token is empty") {
                let token = self.token(accessToken: "")
                expect(token.isAuthorized) == false
            }
        }
    }
    
    private func token(withExpirationDate date: Date = Date(),
                       accessToken: String = "aTokenString",
                       type: TokenType = .keycloak) -> Token {
        return Token(accessToken: accessToken,
                     tokenType: type,
                     expirationDate: date,
                     refreshToken: "aRefreshToken",
                     authenticationType: .keycloak)
    }

}
