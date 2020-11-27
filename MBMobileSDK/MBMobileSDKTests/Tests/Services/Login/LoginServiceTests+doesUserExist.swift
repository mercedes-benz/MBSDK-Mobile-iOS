//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Quick
import Nimble

import MBNetworkKit
import MBCommonKit

@testable import MBMobileSDK

class LoginServiceTests_DoesUserExist: QuickSpec {

    override func spec() {
        var loginService: LoginService!
        
        var userLoginFunctions: MockUserLoginFunctions!
        var nonceStore: MockNonceStore!
        var activeLoginProviderFilter: MockActiveLoginProviderFilter!
        
        let username = "userName"
        
        beforeEach {
            userLoginFunctions = MockUserLoginFunctions()
            activeLoginProviderFilter = MockActiveLoginProviderFilter()
            nonceStore = MockNonceStore()
            loginService = LoginService(authenticationProviders: [],
                                        loginBuilder: MockLoginProviderFactory(providers: []),
                                        dbStore: MockUserDBStore(),
                                        userFunctions: MockUserService(),
                                        userLoginFunctions: userLoginFunctions,
                                        nonceHelper: MockNonceHelper(),
                                        tokenStore: MockTokenStore(),
                                        nonceStore: nonceStore,
                                        activeLoginProviderFilter: activeLoginProviderFilter)
        }
        
        afterEach {
            IngressKit.preferredAuthenticationType = .keycloak
        }
        
        describe("doesUserExist") {
            it("should use the preferred auth method for the request") {
                IngressKit.preferredAuthenticationType = .ciam
                userLoginFunctions.onInitiateLogin = { username, nonce, preferredAuthType in
                    expect(preferredAuthType) == .ciam
                    return (nil, nil)
                }

                loginService.doesUserExist(username: username) { _ in }
            }
            
            it("should use the correct nonce for the request") {
                userLoginFunctions.onInitiateLogin = { username, nonce, preferredAuthType in
                    expect(nonce) == MockNonceHelper.nonce
                    return (nil, nil)
                }
                
                loginService.doesUserExist(username: username) { _ in }
            }
            
            it("should remember the nonce for later") {
                userLoginFunctions.onInitiateLogin = { _,_,_ in return (nil, nil) }
                loginService.doesUserExist(username: username) { _ in }
                
                expect(nonceStore.nonce()) == MockNonceHelper.nonce
            }

            it("should remember the servers response auth type on successful request") {
                expect(activeLoginProviderFilter.bffResponseAuthType).to(beNil())
                
                userLoginFunctions.onInitiateLogin = { _,_,_ in
                    return ((self.userExistModel, .ciam), nil)
                }
                
                loginService.doesUserExist(username: username) { _ in }
                
                expect(activeLoginProviderFilter.bffResponseAuthType) == .ciam
            }
            
            it("should remember the servers response auth type on failure case registration") {
                expect(activeLoginProviderFilter.bffResponseAuthType).to(beNil())
                
                userLoginFunctions.onInitiateLogin = { _,_,_ in
                    return (nil, .userNotFound(self.userExistModel, .ciam))
                }
                
                loginService.doesUserExist(username: username) { _ in }
                
                expect(activeLoginProviderFilter.bffResponseAuthType) == .ciam
            }
            
            it("should complete successfuly if the backend request was successful") {
                userLoginFunctions.onInitiateLogin = { _,_,_ in
                    return ((self.userExistModel, .ciam), nil)
                }
                
                loginService.doesUserExist(username: username) { result in
                    switch result {
                    case .success(let userModel):
                        expect(userModel) == self.userExistModel
                    case .failure: fail("result should be a success")
                    }
                }
            }
            
            it("should complete unsuccessfuly if the backend request did fail") {
                userLoginFunctions.onInitiateLogin = { _,_,_ in
                    return (nil, LoginServiceError.fetchUserError(.network(nil)))
                }
                
                loginService.doesUserExist(username: username) { result in
                    switch result {
                    case .success: fail("result should be a failure")
                    case .failure(let error):
                        expect(error).to(matchError(LoginServiceError.fetchUserError(.network(nil))))
                    }
                }
            }
        }
    }
    
    private var userExistModel: UserExistModel {
        return UserExistModel(isEmail: true, username: "a-username")
    }
    
}


class MockActiveLoginProviderFilter: ActiveLoginProviderFiltering {
    
    var returnedActiveLoginProvider: LoginProvider? = MockLoginProvider()
    var bffResponseAuthType: AuthenticationType?
    
    func activeLoginProvider(loginProviders: [LoginProvider], preferredAuthenticationType: AuthenticationType?) -> LoginProvider? {
        return returnedActiveLoginProvider
    }
    
    func update(bffResponseAuthType: AuthenticationType?) {
        self.bffResponseAuthType = bffResponseAuthType
    }
}
