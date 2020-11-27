//
//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Quick
import Nimble

@testable import MBMobileSDK

class ActiveLoginProviderFilterTests: QuickSpec {

    override func spec() {
        var mockTokenStore: MockTokenStore!
        var keycloakLoginProvider: MockLoginProvider!
        var ciamLoginProvider: MockLoginProvider!
        var loginProviders: [MockLoginProvider]!
        
        var subject: ActiveLoginProviderFiltering!
        
        beforeEach {
            keycloakLoginProvider = MockLoginProvider()
            ciamLoginProvider = MockLoginProvider(type: .ciam)
            loginProviders = [keycloakLoginProvider, ciamLoginProvider]
            mockTokenStore = MockTokenStore()
            subject = ActiveLoginProviderFilter(tokenStore: mockTokenStore)
        }
        
        describe("when there is no token and no bffResponse for auth type") {
            it("should filter the LoginProviders based on the preferredAuthenticationType") {
                guard let filteredLoginProvider = subject.activeLoginProvider(loginProviders: loginProviders, preferredAuthenticationType: .keycloak) as? MockLoginProvider else {
                    fail()
                    return
                }
                
                expect(filteredLoginProvider).to(equal(keycloakLoginProvider))
            }
        }
        
        describe("when there is no token in store") {
            it("should filter the LoginProviders based on the bffResponse") {
                subject.update(bffResponseAuthType: .ciam)
                guard let filteredLoginProvider = subject.activeLoginProvider(loginProviders: loginProviders, preferredAuthenticationType: .keycloak) as? MockLoginProvider else {
                    fail()
                    return
                }
                
                expect(filteredLoginProvider).to(equal(ciamLoginProvider))
            }
            
            it("should filter the LoginProviders based on the bffResponse") {
                subject.update(bffResponseAuthType: .keycloak)
                guard let filteredLoginProvider = subject.activeLoginProvider(loginProviders: loginProviders, preferredAuthenticationType: .ciam) as? MockLoginProvider else {
                    fail()
                    return
                }
                
                expect(filteredLoginProvider).to(equal(keycloakLoginProvider))
            }
        }
        
        describe("when there is a token in store") {
            it("should filter the LoginProviders based on the token") {
                mockTokenStore.savedToken = Token(accessToken: "asd", tokenType: .ciam, expirationDate: Date.distantFuture, refreshToken: "asd", authenticationType: .ciam)
                
                subject.update(bffResponseAuthType: .keycloak)
                
                guard let filteredLoginProvider = subject.activeLoginProvider(loginProviders: loginProviders, preferredAuthenticationType: .keycloak) as? MockLoginProvider else {
                    fail()
                    return
                }
                
                expect(filteredLoginProvider).to(equal(ciamLoginProvider))
            }
            
            it("should filter the LoginProviders based on the token") {
                mockTokenStore.savedToken = Token(accessToken: "asd", tokenType: .keycloak, expirationDate: Date.distantFuture, refreshToken: "asd", authenticationType: .keycloak)
                
                subject.update(bffResponseAuthType: .ciam)
                
                guard let filteredLoginProvider = subject.activeLoginProvider(loginProviders: loginProviders, preferredAuthenticationType: .keycloak) as? MockLoginProvider else {
                    fail()
                    return
                }
                
                expect(filteredLoginProvider).to(equal(keycloakLoginProvider))
            }
        }
    }

}
