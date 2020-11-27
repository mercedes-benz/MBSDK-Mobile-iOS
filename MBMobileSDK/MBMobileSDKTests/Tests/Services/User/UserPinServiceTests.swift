//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Quick
import Nimble

import MBNetworkKit

@testable import MBMobileSDK

public class UserPinServiceTests: QuickSpec {
    
    let userModel = UserModelHelper.build()
    
    public override func spec() {
        
        var service: UserPinService!
        
        var mockLoginService: MockLoginService!
        var mockUserService: MockUserService!
        var mockNetworking: MockNetworking!
        var mockJsonConverter: MockJsonConvertible!
        
        beforeEach {
            mockLoginService = MockLoginService()
            mockNetworking = MockNetworking()
            mockJsonConverter = MockJsonConvertible()
            mockUserService = MockUserService()
            
            service = UserPinService(loginService: mockLoginService,
                                     userService: mockUserService,
                                     networking: mockNetworking,
                                     jsonConverter: mockJsonConverter)
            
            mockLoginService.onTokenRefresh = { ("aToken", nil) }
            mockUserService.currentUser = self.userModel
        }
        
        // should return an error of the user enters a wrong pin for an action that requires a pin confirmation
        describe("wrong pin entry") {
            beforeEach {
                mockNetworking.onRequest = { _ in
                    return (nil, MBError(description: "pin invalid", type: .http(.forbidden(data: nil))))
                }
            }
            
            it("updateBiometricAuthSettings") {
                service.updateBiometricAuthSettings(pinModel: self.pinValidationModel()) { result in
                    self.assertPinInvalid(forResult: result)
                }
            }
            
            it("change") {
                mockJsonConverter.jsonResult = ["newPin": "4321"]
                service.change(currentPin: "1234", newPin: "4321") { result in
                    self.assertPinInvalid(forResult: result)
                }
            }
            
            it("delete") {
                service.delete(pin: "1234") { result in
                    self.assertPinInvalid(forResult: result)
                }
            }
        }

        
        describe("updateBiometricAuthSettings") {
            it("should successfully update the biometric setting") {

                mockNetworking.onRequest = { route in
                    guard case BffUserRouter.biometric(let accessToken, let dict) = route else {
                        fail()
                        return (nil, nil)
                    }
                    
                    expect(accessToken) == "aToken"
                    expect(dict?["action"] as? String) == "enabled"
                    expect(dict?["pin"] as? String) == "aPin"

                    return (nil, nil)
                }
                
                service.updateBiometricAuthSettings(pinModel: self.pinValidationModel()) { result in
                    switch result {
                    case .success(let userModel): success()
                    case .failure: fail()
                    }
                }
            }
        }
        
        describe("change") {
            it("should successfully change the users pin") {
                mockJsonConverter.jsonResult = ["newPin": "1234"]
                mockNetworking.onRequest = { route in
                    guard case BffPinRouter.change(let accessToken, let dict) = route else {
                        fail()
                        return (nil, nil)
                    }
                    
                    expect(accessToken) == "aToken"
                    expect(dict?["newPin"] as? String) == "1234"

                    return (nil, nil)
                }
                
                service.change(currentPin: "1234", newPin: "4321") { result in
                    switch result {
                    case .success(let userModel): success()
                    case .failure: fail()
                    }
                }
            }
            
            it("should return an error if the payload is invalid") {
                service.change(currentPin: "1234", newPin: "4321") { result in
                    switch result {
                    case .success: fail()
                    case .failure(let error):
                        switch error {
                        case .invalidInputs(let inputs):
                            if let inputs = inputs as? [String: String] {
                                expect(inputs) == ["currentPin": "1234", "newPin": "4321"]
                            } else {
                                fail()
                            }
                        default: fail()
                        }
                    }
                }
            }
        }
        
        describe("delete") {
            it("should successfully delete the users pin") {
                mockNetworking.onRequest = { route in
                    guard case BffPinRouter.delete(let accessToken, let pin) = route else {
                        fail()
                        return (nil, nil)
                    }
                    
                    expect(accessToken) == "aToken"
                    expect(pin) == "1234"

                    return (nil, nil)
                }
                
                service.delete(pin: "1234") { result in
                    switch result {
                    case .success(let userModel): success()
                    case .failure: fail()
                    }
                }
            }
        }
        
        describe("reset") {
            it("should successfully reset the users pin") {
                mockNetworking.onRequest = { route in
                    guard case BffPinRouter.reset(let accessToken) = route else {
                        fail()
                        return (nil, nil)
                    }
                    
                    expect(accessToken) == "aToken"
                    
                    return (nil, nil)
                }
                
                service.reset() { result in
                    switch result {
                    case .success(let userModel): success()
                    case .failure: fail()
                    }
                }
            }
        }
        
        describe("set") {
            it("should successfully set the users pin") {
                mockJsonConverter.jsonResult = ["newPin": "1234"]
                mockNetworking.onRequest = { route in
                    
                    guard case BffPinRouter.set(let accessToken, let dict) = route else {
                        fail()
                        return (nil, nil)
                    }
                    
                    expect(accessToken) == "aToken"
                    expect(dict?["newPin"] as? String) == "1234"

                    return (nil, nil)
                }
                
                service.set(newPin: "1234") { result in
                    switch result {
                    case .success(let userModel): success()
                    case .failure: fail()
                    }
                }
            }
            
            it("should return an error if the payload is invalid") {
                service.set(newPin: "4321") { result in
                    switch result {
                    case .success: fail()
                    case .failure(let error):
                        switch error {
                        case .invalidInputs(let inputs):
                            if let inputs = inputs as? [String: String] {
                                expect(inputs) == ["newPin": "4321"]
                            } else {
                                fail()
                            }
                        default: fail()
                        }
                    }
                }
            }
        }
    }
    
    private func assertUserModel(_ model: UserModel) {
        expect(model) == self.userModel
    }
    
    private func assertPinInvalid(forResult result: Result<UserModel, UserPinServiceError>) {
        switch result {
        case .success: fail()
        case .failure(let error):
            switch error {
            case .pinIncorrect: success()
            default: fail()
            }
        }
    }
    
    private func pinValidationModel() -> PinValidationModel {
        return PinValidationModel(biometricAuthenticationEnabled: true, pin: "aPin")
    }
    
}
