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

class LoginServiceTests: QuickSpec {
    
    override func spec() {
        
        var loginService: LoginService!
        
        var loginProvider: MockLoginProvider!
        var loginProviderCIAM: MockLoginProvider!
        var loginProviders: [MockLoginProvider]!
        var dbStore: MockUserDBStore!
        var userFunctions: MockUserService!
        var factory: MockLoginProviderFactory!
        var tokenStore: MockTokenStore!
        var nonceStore: MockNonceStore!
        var activeLoginProviderFilter: MockActiveLoginProviderFilter!
        
        let username = "userName"
        let mockPin = "1234"
        
        beforeEach {
            // will be "build" by the factory and used by loginService to do pretty much everything
            loginProvider = MockLoginProvider()
            loginProviderCIAM = MockLoginProvider(type: .ciam)
            loginProviders = [loginProvider, loginProviderCIAM]
            
            factory = MockLoginProviderFactory(providers: loginProviders)
            dbStore = MockUserDBStore()
            userFunctions = MockUserService()
            tokenStore = MockTokenStore()
            nonceStore = MockNonceStore()
            activeLoginProviderFilter = MockActiveLoginProviderFilter()
            
            loginService = LoginService(authenticationProviders: [MockAuthenticationProviding(type: .keycloak),
                                                                  MockAuthenticationProviding(type: .ciam)],
                                        loginBuilder: factory,
                                        dbStore: dbStore,
                                        userFunctions: userFunctions,
                                        userLoginFunctions: MockUserLoginFunctions(),
                                        nonceHelper: MockNonceHelper(),
                                        tokenStore: tokenStore,
                                        nonceStore: nonceStore,
                                        activeLoginProviderFilter: activeLoginProviderFilter)
        }
        
        describe("login") {
            beforeEach {
                nonceStore.save(nonce: MockNonceHelper.nonce)
            }

            it("should return success if the login and user fetch was successful") {
                loginProvider.onLogin = { name, credential in
                    if name == username && credential == mockPin {
                        return (true, nil)
                    } else {
                        fail()
                        return (false, nil)
                    }
                }
                
                activeLoginProviderFilter.returnedActiveLoginProvider = loginProvider

                userFunctions.currentUser = UserModelHelper.build()

                loginService.login(username: username, pin: mockPin) { result in
                    switch result {
                    case .success:
                        expect(userFunctions.fetchUserWasCalled) == true
                    case .failure: fail()
                    }
                }
            }
            
            it("should use the correct credential for keycloak") {
                loginProvider.onLogin = { name, credential in
                    if name == username && credential == mockPin {
                        return (true, nil)
                    } else {
                        fail()
                        return (false, nil)
                    }
                }
                
                activeLoginProviderFilter.returnedActiveLoginProvider = loginProvider

                userFunctions.currentUser = UserModelHelper.build()

                loginService.login(username: username, pin: mockPin) { result in
                    switch result {
                    case .success:
                        expect(userFunctions.fetchUserWasCalled) == true
                    case .failure: fail()
                    }
                }
            }
            
            it("should use the correct credential for ciam") {
                
                loginProviderCIAM.onLogin = { name, credential in
                    // MockNonceHelper.nonce
                    if name == username && credential == "\(MockNonceHelper.nonce):\(mockPin)" {
                        return (true, nil)
                    } else {
                        fail()
                        return (false, nil)
                    }
                }
                activeLoginProviderFilter.returnedActiveLoginProvider = loginProviderCIAM

                userFunctions.currentUser = UserModelHelper.build()

                loginService.login(username: username, pin: mockPin) { result in
                    switch result {
                    case .success:
                        expect(userFunctions.fetchUserWasCalled) == true
                    case .failure: fail()
                    }
                }
            }
            
            it("should fail if no nonce is available from previous BFF /login request") {
                nonceStore.save(nonce: nil)
                
                loginService.login(username: username, pin: mockPin) { result in
                    switch result {
                    case .success: fail()
                    case .failure(let error):
                        expect(error).to(matchError(LoginServiceError.loginDidFail(nil)))
                    }
                }
            }
            
            it("should not try to fetch a user on failure") {
                loginProvider.onLogin = { _,_ in return (false, LoginServiceError.unknown) }
                activeLoginProviderFilter.returnedActiveLoginProvider = loginProvider
                
                loginService.login(username: username, pin: mockPin) { result in
                    switch result {
                    case .success: fail()
                    case .failure(let error):
                        expect(userFunctions.fetchUserWasCalled).to(beFalse())
                        expect(error).to(matchError(LoginServiceError.unknown))
                    }
                }
            }

            it("should return an error if login is successful but user fetch did fail") {
                loginProvider.onLogin = { _,_ in return (true, nil) }
                activeLoginProviderFilter.returnedActiveLoginProvider = loginProvider

                // make fetch user fail
                userFunctions.currentUser = nil
                
                loginService.login(username: username, pin: mockPin) { result in
                    switch result {
                    case .success: fail()
                    case .failure(let error):
                        expect(userFunctions.fetchUserWasCalled) == true
                        expect(error).to(matchError(LoginServiceError.fetchUserError(.network(nil))))
                    }
                }
            }
        }
        
        describe("logout") {
            it("should return success if the logout was successful") {
                loginProvider.onLogout = { return (true, nil) }
                activeLoginProviderFilter.returnedActiveLoginProvider = loginProvider
                
                loginService.logout { result in
                    switch result {
                    case .success: pass()
                    case .failure: fail()
                    }
                }
            }
            
            it("should return an error if logout failed") {
                loginProvider.onLogout = { return (false, LoginServiceError.unknown) }
                activeLoginProviderFilter.returnedActiveLoginProvider = loginProvider
                
                loginService.logout { result in
                    switch result {
                    case .success: fail()
                    case .failure(let error):
                        expect(error).to(matchError(LoginServiceError.unknown))
                    }
                }
            }
            
            it("should delete the user from cache after successful logout") {
                loginProvider.onLogout = { return (true, nil) }
                activeLoginProviderFilter.returnedActiveLoginProvider = loginProvider
                
                loginService.logout { result in
                    switch result {
                    case .success: success()
                    case .failure: fail()
                    }
                }
            }
            
            it("should complete with error when the user can not be deleted from cache after successful logout") {
                loginProvider.onLogout = { return (true, nil) }
                activeLoginProviderFilter.returnedActiveLoginProvider = loginProvider
                
                dbStore.deleteSucceeds = false
                
                loginService.logout { result in
                    switch result {
                    case .success: fail()
                    case .failure(let error):
                        expect(error).to(matchError(LoginServiceError.logoutDeleteUserFromDB))
                    }
                }
            }
            
            it("should not delete the user from cache if logout failed") {
                loginProvider.onLogout = { return (false, LoginServiceError.unknown) }
                activeLoginProviderFilter.returnedActiveLoginProvider = loginProvider
                
                loginService.logout { _ in
                    expect(dbStore.deleteWasCalled) == false
                }
            }
        }
        
        describe("refreshTokenIfNeeded") {
            it("should return a token if the refresh was successful") {
                let mockToken = TokenTestHelper.token
                loginProvider.onRefreshToken = { return (mockToken, nil) }
                activeLoginProviderFilter.returnedActiveLoginProvider = loginProvider
                
                loginService.refreshTokenIfNeeded { result in
                    switch result {
                    case .success(let token):
                        expect(token) == mockToken
                        
                    case .failure: fail()
                    }
                }
            }
            
            it("should return an error if the refresh did fail") {
                loginProvider.onRefreshToken = { return (nil, MBError(description: nil, type: .unknown)) }
                activeLoginProviderFilter.returnedActiveLoginProvider = loginProvider
                
                loginService.refreshTokenIfNeeded { result in
                    switch result {
                    case .success: fail()
                    case .failure(let error):
                        expect(error.type) == .unknown
                    }
                }
            }
        }
    }

    
    // MARK: - Helpers
    
    private var authenticationProviding: AuthenticationProviding {
        return MockAuthenticationProviding()
    }
    
    // MARK: - Mocks
    private class MockAuthenticationProviding: AuthenticationProviding {
        var type: AuthenticationType
        
        init(type: AuthenticationType = .keycloak) {
            self.type = type
        }
    }
}

class MockNonceHelper: NonceHelping {
    static var nonce = "a-nonce"
    
    func getNonce() -> String {
        return MockNonceHelper.nonce
    }
}

class MockUserDBStore: UserDbStoreRepresentable {
    
    var deleteWasCalled = false
    var deleteSucceeds = true
    
    var currentUser: UserModel?
    
    // unused
    func save(user: UserModel, completion: @escaping ((Result<UserModel, UserDbStoreError>) -> Void)) {
        fail()
    }
    
    func deleteCurrentUser(completion: @escaping ((Result<Void, UserDbStoreError>) -> Void)) {
        self.deleteWasCalled = true
        
        if self.deleteSucceeds {
            self.currentUser = nil
            completion(.success(()))
        } else {
            completion(.failure(.dbError))
        }
    }
}
