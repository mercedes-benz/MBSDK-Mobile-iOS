//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Quick
import Nimble

@testable import MBMobileSDK

class ROPCEndpointRouterTest: QuickSpec {

    override func spec() {
         
        var mockProvider: ROPCAuthenticationProviderMock!

        beforeEach {
            mockProvider = ROPCAuthenticationProviderMock(sdkVersion: "1.0")
        }
        
        describe("general router behaviour") {
            var loginRoute: ROPCEndpointRouter!
            var logoutRoute: ROPCEndpointRouter!
            var refreshRoute: ROPCEndpointRouter!
            
            beforeEach {
                loginRoute = ROPCEndpointRouter.login(provider: mockProvider, username: "username", credential: "credential")
                logoutRoute = ROPCEndpointRouter.logout(provider: mockProvider, token: "token")
                refreshRoute = ROPCEndpointRouter.refresh(provider: mockProvider, token: "token")
            }
            
            describe("baseURL") {
                it("should use the bffProvider baseUrl") {
                    expect(loginRoute.baseURL) == mockProvider.urlProvider.baseUrl
                    expect(logoutRoute.baseURL) == mockProvider.urlProvider.baseUrl
                    expect(refreshRoute.baseURL) == mockProvider.urlProvider.baseUrl
                }
            }
    
            it("should have all default headers") {
                assert(subset: mockProvider.headerParamProvider.defaultHeaderParams, toBeIn: loginRoute.httpHeaders!)
                assert(subset: mockProvider.headerParamProvider.defaultHeaderParams, toBeIn: logoutRoute.httpHeaders!)
                assert(subset: mockProvider.headerParamProvider.defaultHeaderParams, toBeIn: refreshRoute.httpHeaders!)
            }
            
            it("should do post requests") {
                expect(loginRoute.method) == .post
                expect(logoutRoute.method) == .post
                expect(refreshRoute.method) == .post
            }
            
            it("should use url standard parameter encoding") {
                expect(loginRoute.parameterEncoding) == .url(type: .standard)
                expect(logoutRoute.parameterEncoding) == .url(type: .standard)
                expect(refreshRoute.parameterEncoding) == .url(type: .standard)
            }
            
            it("should have no cache policy") {
                expect(loginRoute.cachePolicy).to(beNil())
                expect(logoutRoute.cachePolicy).to(beNil())
                expect(refreshRoute.cachePolicy).to(beNil())
            }
            
            it("should use the providers timeout") {
                expect(loginRoute.timeout) == mockProvider.urlProvider.requestTimeout
                expect(logoutRoute.timeout) == mockProvider.urlProvider.requestTimeout
                expect(refreshRoute.timeout) == mockProvider.urlProvider.requestTimeout
            }
        }
        
        describe("login") {
            var loginRoute: ROPCEndpointRouter!
            
            beforeEach {
                loginRoute = ROPCEndpointRouter.login(provider: mockProvider, username: "username", credential: "credential")
            }
            
            it("should have extra http header") {
                expect(loginRoute.httpHeaders?["Stage"]) == mockProvider.stageName
                expect(loginRoute.httpHeaders?["device-uuid"]?.isEmpty) == false
            }
            
            describe("path") {
                it("should use the correct keycloak path for keycloak auth type") {
                    expect(loginRoute.path) == "/protocol/openid-connect/token"
                }
                
                it("should use the correct ciam path for ciam auth type") {
                    mockProvider.mockAuthType = .ciam
                    expect(loginRoute.path) == "/as/token.oauth2"
                }
            }
            
            it("should use the correct parameters") {
                let params = loginRoute.parameters as! [String: String]
                expect(params[ROPCParamKey.clientId]) == mockProvider.clientId
                expect(params[ROPCParamKey.grantType]) == ROPCParamValue.password
                expect(params[ROPCParamKey.scope]) == mockProvider.scopes
                expect(params[ROPCParamKey.username]) == "username"
                expect(params[ROPCParamKey.password]) == "credential"
                expect(params.count) == 5
            }
        }
        
        describe("logout") {
            var logoutRoute: ROPCEndpointRouter!
            
            beforeEach {
                logoutRoute = ROPCEndpointRouter.logout(provider: mockProvider, token: "token")
            }
            
            it("should have extra http header") {
                expect(logoutRoute.httpHeaders?["Stage"]) == mockProvider.stageName
            }

            describe("path") {
                it("should use the correct keycloak path for keycloak auth type") {
                    expect(logoutRoute.path) == "/protocol/openid-connect/logout"
                }
                
                it("should use the correct ciam path for ciam auth type") {
                    mockProvider.mockAuthType = .ciam
                    expect(logoutRoute.path) == "/as/revoke_token.oauth2"
                }
            }
            
            it("should use the correct parameters") {
                let params = logoutRoute.parameters as! [String: String]
                expect(params[ROPCParamKey.clientId]) == mockProvider.clientId
                expect(params[ROPCParamKey.refreshToken]) == "token"
                expect(params.count) == 2
            }
        }
        
        describe("refresh") {
            var refreshRoute: ROPCEndpointRouter!
            
            beforeEach {
                refreshRoute = ROPCEndpointRouter.refresh(provider: mockProvider, token: "token")
            }
            
            it("should have extra http header") {
                expect(refreshRoute.httpHeaders?["Stage"]) == mockProvider.stageName
            }
            
            describe("path") {
                it("should use the correct keycloak path for keycloak auth type") {
                    expect(refreshRoute.path) == "/protocol/openid-connect/token"
                }
                
                it("should use the correct ciam path for ciam auth type") {
                    mockProvider.mockAuthType = .ciam
                    expect(refreshRoute.path) == "/as/token.oauth2"
                }
            }
            
            it("should use the correct parameters") {
                let params = refreshRoute.parameters as! [String: String]
                expect(params[ROPCParamKey.clientId]) == mockProvider.clientId
                expect(params[ROPCParamKey.grantType]) == ROPCParamValue.refreshToken
                expect(params[ROPCParamKey.refreshToken]) == "token"
                expect(params.count) == 3
            }
        }
        
    }

}
