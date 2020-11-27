//
//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Quick
import Nimble

import MBNetworkKit
import MBCommonKit
import MBRealmKit

@testable import MBMobileSDK

class CIAMTokenExchangeServiceTests: QuickSpec {
    
    override func spec() {
        
        var tokenExchangeService: CIAMTokenExchangeService!
        
        var mockLoginService: MockLoginService!
        var mockUserService: MockUserService!
        var mockFactory: MockLoginProviderFactory!
        var mockTokenStore: MockTokenStore!
        
        beforeEach {
            mockLoginService = MockLoginService()
            mockUserService = MockUserService()
            mockFactory = MockLoginProviderFactory(providers: [])
            mockTokenStore = MockTokenStore()
            
            tokenExchangeService = CIAMTokenExchangeService(loginService: mockLoginService,
                                                            userService: mockUserService,
                                                            loginProviderFactory: mockFactory,
                                                            tokenStore: mockTokenStore)
        }
        
        describe("isTokenExchangePossible") {
            it("should be false if the token is not in status logged in") {
                mockLoginService.token = Token(accessToken: "", tokenType: .keycloak, expirationDate: Date(), refreshToken: "xx", authenticationType: .keycloak)
                
                expect(tokenExchangeService.isTokenExchangePossible()) == false
            }
            
            it("should be false if the token is not a keycloak token") {
                mockLoginService.token = Token(accessToken: "xxxx", tokenType: .ciam, expirationDate: Date(), refreshToken: "xx", authenticationType: .ciam)
                
                expect(tokenExchangeService.isTokenExchangePossible()) == false
            }
            
            it("should be false if there is no ciam config available") {
                IngressKit.filteredAuthenticationProviders = []
                expect(tokenExchangeService.isTokenExchangePossible()) == false
            }
            
            it("should be true if all preconditions are fullfilled") {
                mockLoginService.token = Token(accessToken: "xxxx", tokenType: .keycloak, expirationDate: Date(), refreshToken: "xx", authenticationType: .keycloak)
                IngressKit.filteredAuthenticationProviders = [DefaultCiamProvider(clientIdentifier: "xx", sdkVersion: "yy")]
                
                expect(tokenExchangeService.isTokenExchangePossible()) == true
            }
        }
        
        describe("performLogin") {
            context("fails before the exchange was tried to be performed") {
                it("should fail if no valid auth config is available") {
                    IngressKit.filteredAuthenticationProviders = []
                    
                    tokenExchangeService.performTokenExchange { result in
                        switch result {
                        case .success: fail()
                        case .failure(let error):
                            expect(error).to(matchError(TokenExchangeError.noValidAuthConfigAvailable))
                        }
                    }
                }
                
                it("should fail if no login provider could be built with the auth config") {
                    IngressKit.filteredAuthenticationProviders = [DefaultCiamProvider(clientIdentifier: "xx", sdkVersion: "yy")]
                    mockFactory.providers = []
                    
                    tokenExchangeService.performTokenExchange { result in
                        switch result {
                        case .success: fail()
                        case .failure(let error):
                            expect(error).to(matchError(TokenExchangeError.noValidAuthConfigAvailable))
                        }
                    }
                }
                
                it("should fail if no token is currently available for exchange") {
                    IngressKit.filteredAuthenticationProviders = [DefaultCiamProvider(clientIdentifier: "xx", sdkVersion: "yy")]
                    mockFactory.providers = [MockLoginProvider(type: .ciam)]
                    
                    tokenExchangeService.performTokenExchange { result in
                        switch result {
                        case .success: fail()
                        case .failure(let error):
                            expect(error).to(matchError(TokenExchangeError.currentTokenNotAvailable))
                        }
                    }
                }
                
                it("should fail if the user has no valid authentication identifier") {
                    IngressKit.filteredAuthenticationProviders = [DefaultCiamProvider(clientIdentifier: "xx", sdkVersion: "yy")]
                    mockFactory.providers = [MockLoginProvider(type: .ciam)]
                    mockLoginService.token = Token(accessToken: "xx", tokenType: .keycloak, expirationDate: Date(), refreshToken: "xx", authenticationType: .keycloak)
                    
                    tokenExchangeService.performTokenExchange { result in
                        switch result {
                        case .success: fail()
                        case .failure(let error):
                            expect(error).to(matchError(TokenExchangeError.invalidUserAuthenticationIdentifier))
                        }
                    }
                }
            }
            
            context("preconditions are met and exchange was tried") {
                var provider: MockLoginProvider!
                
                beforeEach {
                    IngressKit.filteredAuthenticationProviders = [DefaultCiamProvider(clientIdentifier: "xx", sdkVersion: "yy")]
                    provider = MockLoginProvider(type: .ciam)
                    mockFactory.providers = [provider]
                    mockLoginService.token = Token(accessToken: "xx", tokenType: .keycloak,
                                                   expirationDate: Date(), refreshToken: "xx",
                                                   authenticationType: .keycloak)
                    mockUserService.currentUser = UserModelHelper.build()
                }
                
                it("should succeed if a new ciam token is available") {
                    provider.onLogin = { _,_ in return (true, nil) }
                    
                    tokenExchangeService.performTokenExchange { result in
                        switch result {
                        case .success: success()
                        case .failure: fail()
                        }
                    }
                }
                
                it("should fail if the exchange request failed") {
                    tokenExchangeService.performTokenExchange { result in
                        switch result {
                        case .success: fail()
                        case .failure(let error):
                            expect(error).to(matchError(TokenExchangeError.tokenExchangeFailed))
                        }
                    }
                }
            }
            
        }
    }
    
    // MARK: - Mocks
    private class MockAuthenticationProviding: AuthenticationProviding {
        var type: AuthenticationType
        
        init(type: AuthenticationType = .keycloak) {
            self.type = type
        }
    }
}

