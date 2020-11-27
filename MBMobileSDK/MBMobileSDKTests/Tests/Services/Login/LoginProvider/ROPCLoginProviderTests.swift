//
//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Quick
import Nimble
import Foundation
import MBCommonKit
@testable import MBNetworkKit
@testable import MBMobileSDK

class ROPCLoginProviderTests: QuickSpec {

    
    
    override func spec() {
        
        var tokenStore: MockTokenStore!
        var networkService: MockNetworking!
        var subject: ROPCLoginProvider!
        
        beforeEach {
            networkService = MockNetworking()
            tokenStore = MockTokenStore()
            subject = ROPCLoginProvider(config: MockROPCConfig(),
                                        tokenStore: tokenStore,
                                        networkService: networkService)
        }
        
        context("login") {
            describe("when login request fails") {
                beforeEach {
                    _ = tokenStore.save(TokenTestHelper.token)
                }
                
                it("should complete with error and reset login token") {
                    let rqError = MBError(description: "anError", type: .network(.unknown))
                    networkService.onRequest = { _ in return (nil, rqError) }
                    
                    subject.login(username: "asd", credential: "credential") { result in
                        switch result {
                        case .failure(let error):
                            expect(tokenStore.savedToken).to(beNil())
                            expect(error).to(matchError(LoginServiceError.loginDidFail(rqError)))
                        case .success:
                            fail()
                        }
                    }
                }
                
                it("should return a loginDidFailWithInvalidPin error if the pin was incorrect") {
                    networkService.onRequest = { route in
                        return (nil, MBError(description: "something invalid_grant something", type: .network(.unknown)))
                    }
                    
                    subject.login(username: "asd", credential: "credential") { result in
                        switch result {
                        case .failure(let error):
                            expect(tokenStore.savedToken).to(beNil())
                            expect(error).to(matchError(LoginServiceError.loginDidFailWithInvalidPin))
                        
                        case .success: fail()
                        }
                    }
                }
            }
            
            describe("when login request succeeds") {
                it("should complete with success and save the new token in the store") {
                    let token = TokenTestHelper.token
                    _ = tokenStore.save(token)
                    
                    networkService.onRequest = { route in return (self.apiLoginModel(), nil) }

                    subject.login(username: "asd", credential: "credential") { result in
                        switch result {
                        case .failure:
                            fail()
                        case .success:
                            expect(tokenStore.savedToken?.accessToken) == token.accessToken
                            expect(tokenStore.savedToken?.refreshToken) == token.refreshToken
                            expect(tokenStore.savedToken?.tokenType) == token.tokenType
                            expect(tokenStore.savedToken?.authenticationType) == token.authenticationType
                        }
                    }
                }
                
                it("should complete with failure when token could not be saved") {
                    tokenStore.saveSucceeds = false
                    networkService.onRequest = { router in (self.apiLoginModel(), nil) }
                    
                    subject.login(username: "asd", credential: "credential") { result in
                        switch result {
                        case .failure:
                            expect(tokenStore.savedToken).to(beNil())
                        case .success:
                            fail()
                        }
                    }
                }
            }
        }
        
        context("logout") {
            describe("when there is no token") {
                it("should return an not authorized error") {
                    subject.logout { result in
                        switch result {
                        case .failure(let error):
                            expect(error).to(matchError(LoginServiceError.logoutDidFail(nil)))
                        case .success:
                            fail()
                        }
                    }
                }
            }
            
            describe("when logout request succeeds") {
                it("should pass on result and delete token from store") {
                    _ = tokenStore.save(TokenTestHelper.token)
                    networkService.onDataRequest = { router in (Data(), nil) }
                    
                    subject.logout { result in
                        switch result {
                        case .failure:
                            fail()
                        case .success:
                            expect(tokenStore.get()).to(beNil())
                        }
                    }
                }
            }
            
            describe("when logout request fails") {
                it("should pass on result and delete token from store") {
                    _ = tokenStore.save(TokenTestHelper.token)
                    networkService.onDataRequest = { router in (nil, .init(description: nil, type: .unknown)) }
                    
                    subject.logout { result in
                        switch result {
                        case .failure(let error):
                            expect(error).to(matchError(LoginServiceError.logoutDidFail(nil)))
                        case .success:
                            fail()
                        }
                    }
                }
            }
        }
        
        context("refreshTokenIfNeeded") {
            describe("when access token is valid") {
                it("should return exactly this token") {
                    let token = TokenTestHelper.token
                    _ = tokenStore.save(token)
                    
                    subject.refreshTokenIfNeeded { result in
                        switch result {
                        case .success(let resultToken):
                            expect(resultToken).to(equal(token))
                            expect(tokenStore.get()).to(equal(resultToken))
                        case .failure:
                            fail()
                        }
                    }
                }
            }

            describe("when token is unauthorized") {
                it("should complete with error") {
                    subject.refreshTokenIfNeeded { result in
                        switch result {
                        case .success:
                            fail()
                        case .failure(let error):
                            expect(error).to(equal(MBError(description: nil, type: .specificError(LoginError.notAuthorized))))
                            expect(tokenStore.get()).to(beNil())
                        }
                    }
                }
            }
            
            context("token is expired") {
                it("should complete with error if refresh token is not available") {
                    let token = TokenTestHelper.token(expirationDate: Date.distantPast, refreshToken: String() )
                    _ = tokenStore.save(token)
                    
                    subject.refreshTokenIfNeeded { result in
                        switch result {
                        case .success:
                            fail()
                        case .failure(let error):
                            expect(error).to(equal(MBError(description: nil, type: .specificError(LoginError.emptyRefreshToken))))
                            expect(tokenStore.get()).to(equal(token))
                        }
                    }
                }
                
                it("should complete with a fresh token and also save it to the store") {
                    networkService.onRequest = { router in (self.apiLoginModel(), nil) }
                    
                    let token = TokenTestHelper.token(expirationDate: Date.distantPast)
                    _ = tokenStore.save(token)
                    
                    subject.refreshTokenIfNeeded { result in
                        switch result {
                        case .success(let newToken):
                            expect(newToken).toNot(equal(token))
                            expect(tokenStore.get()).to(equal(newToken))
                        case .failure:
                            fail()
                        }
                    }
                }
            }
        }
    }
    
    private func apiLoginModel() -> APILoginModel {
        let token = TokenTestHelper.token
        return APILoginModel(accessToken: token.accessToken,
                             expiresIn: 99999999,
                             refreshToken: token.refreshToken,
                             tokenType: token.tokenType.rawValue)
    }

    private class MockROPCConfig: ROPCAuthenticationProviding {
        var type: AuthenticationType = .keycloak
        
        var clientId: String = "clientid"
        var headerParamProvider: HeaderParamProviding = MockHeaderParamProviding()
        var stageName: String = "prod"
        var urlProvider: UrlProviding = MockUrlProviding()
        var scopes: String = "offline_access something_else"
    }

}
