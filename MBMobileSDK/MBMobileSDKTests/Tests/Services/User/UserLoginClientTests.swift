//
//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Quick
import Nimble

import MBNetworkKit
import MBCommonKit

@testable import MBMobileSDK

class UserLoginClientTests:  QuickSpec {
   
   override func spec() {
    
        var networking: MockNetworking!
        var userService: MockUserService!
    
        var client: UserLoginClient!
    
        let username = "userName"
        let nonce = "1234"
    
        beforeEach {
            IngressKit.bffProvider = BffProviderMock(sdkVersion: "1.0")
            
            networking = MockNetworking()
            userService = MockUserService()
            
            client = UserLoginClient(networking: networking,
                                     userFunctions: userService,
                                     userRegionHelper: MockUserRegionHelping())
        }
    
        describe("initiateLogin") {
            it("should request if a user for the given username exists with keycloak") {
                networking.onRequest = { route in
                    expect({
                        guard case BffUserRouter.exist = route else {
                            return .failed(reason: "wrong enum case")
                        }
                        return .succeeded
                    }).to(succeed())
                    expect(route.bodyParameters?["locale"] as? String) == "de"
                    expect(route.bodyParameters?["countryCode"] as? String) == "DE"
                    expect(route.bodyParameters?["emailOrPhoneNumber"] as? String) == username
                    expect(route.bodyParameters?["nonce"] as? String) == nonce
                    expect(route.httpHeaders?["Authorization"]) == "KEYCLOAK"
                    
                    return (APIUserExistModel(isEmail: true, username: username), nil)
                }
                
                client.initiateLogin(username: username, nonce: nonce, preferredAuthType: .keycloak) { _ in }
            }
            
            it("should request if a user for the given username exists with ciam") {
                networking.onRequest = { route in
                    expect({
                        guard case BffUserRouter.exist = route else {
                            return .failed(reason: "wrong enum case")
                        }
                        return .succeeded
                    }).to(succeed())
                    expect(route.bodyParameters?["locale"] as? String) == "de"
                    expect(route.bodyParameters?["countryCode"] as? String) == "DE"
                    expect(route.bodyParameters?["emailOrPhoneNumber"] as? String) == username
                    expect(route.bodyParameters?["nonce"] as? String) == nonce
                    expect(route.httpHeaders?["Authorization"]) == "CIAMNG"

                    return (APIUserExistModel(isEmail: true, username: username), nil)
                }
                
                client.initiateLogin(username: username, nonce: nonce, preferredAuthType: .ciam) { _ in }
            }
            
            context("backend says user exists") {
                beforeEach {
                    networking.onRequest = { route in
                        return (APIUserExistModel(isEmail: true, username: username), nil)
                    }
                }
                
                it("should return the existing user") {
                    client.initiateLogin(username: username, nonce: nonce, preferredAuthType: .keycloak) { result in
                        switch result {
                        case .success((let userModel, let authType)):
                            expect(userModel.isEmail) == true
                            expect(userModel.username) == username
                            expect(authType) == .keycloak
                        case .failure: fail()
                        }
                    }
                }
            }
            
            context("backend says user does not exist") {
                beforeEach {
                    networking.onRequest = { route in
                        return (APIUserExistModel(isEmail: true, username: ""), nil)
                    }
                }
                
                it("should return an error if the user does not exist yet") {
                    client.initiateLogin(username: username, nonce: nonce, preferredAuthType: .keycloak) { result in
                        switch result {
                        case .success: fail()
                        case .failure(let error):
                            expect(error).to(matchError(LoginServiceError.userNotFound(UserExistModel(isEmail: true, username: ""), .keycloak)))
                        }
                    }
                }
            }
            
            context("backend requests fails") {
                beforeEach {
                    networking.onRequest = { route in
                        return (nil, MBError(description: "anError", type: .network(.unknown)))
                    }
                }
                it("should return an error") {
                    let error = MBError(description: "anError", type: .network(.unknown))
                    
                    networking.onRequest = { route in
                        return (nil, error)
                    }
                    
                    client.initiateLogin(username: username, nonce: nonce, preferredAuthType: .keycloak) { result in
                        switch result {
                        case .success: fail()
                        case .failure(let error):
                            expect(error).to(matchError(LoginServiceError.initiateLoginDidFail(error)))
                        }
                    }
                }
            }
        }
    }
    
    private class MockUserRegionHelping: UserRegionHelping {
        func locale(for user: UserModel?) -> String { return "de" }
        func countryCode(for user: UserModel?) -> String { return "DE" }
    }

}
