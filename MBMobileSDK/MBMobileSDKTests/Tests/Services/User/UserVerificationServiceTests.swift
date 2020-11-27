//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Nimble
import Quick

import MBCommonKit
import MBNetworkKit

@testable import MBMobileSDK

class UserVerificationServiceTests: QuickSpec {
    
    override func spec() {
        
        var networkService: MockNetworking!
        var userVerificationProvider: UserVerificationServiceRepresentable!
        var loginService: MockLoginService!
        var userService: MockUserService!
        
        beforeEach {
            networkService = MockNetworking()
            loginService = MockLoginService()
            userService = MockUserService()
            userVerificationProvider = UserVerificationService(networking: networkService, loginService: loginService, userService: userService)
            
            loginService.onTokenRefresh = { ("accessToken", nil) }
        }
        
        describe("initiateUserVerificationTransaction") {

            it("should return success if verification transaction was successful") {
                networkService.onDataRequest = { _ in (Data(), nil)}
                
                let model = UserVerificationTransactionModel(type: .mobilePhoneNumber, subject: "+49123456789")
                
                userVerificationProvider.initiateUserVerificationTransaction(userVerificationTransaction: model) { (result) in
                    switch result {
                    case .failure:
                        fail()
                    case .success:
                        _ = succeed()
                    }
                }
                
            }
            
            it("should return an error if verification transaction failed") {
                networkService.onDataRequest = { _ in (nil, MBError(description: "mock error", type: MBErrorType.http(.internalServerError(data: nil))))}
                
                let model = UserVerificationTransactionModel(type: .mobilePhoneNumber, subject: "+49123456789")
                
                userVerificationProvider.initiateUserVerificationTransaction(userVerificationTransaction: model) { (result) in
                    switch result {
                    case .failure(let error):
                        expect(error).to(matchError(UserVerificationServiceError.networkError))
                    case .success:
                        fail()
                    }
                }
            }
        }
        
        describe("confirmUserVerification") {

            
            it("should return success if verification confirmation was successful") {
                networkService.onDataRequest = { _ in (Data(), nil)}
                userService.currentUser = UserModel.create(mobilePhoneNumber: "+49123456789")
                
                let input = UserVerificationConfirmationModel(code: "G-123456", type: .mobilePhoneNumber, subject: "+49123456789")
                
                userVerificationProvider.confirmUserVerification(userVerificationConfirmationModel: input) { (result) in
                    switch result {
                    case .failure:
                        fail()
                    case .success(let model):
                        expect(model.mobilePhoneNumber).to(equal("+49123456789"))
                    }
                }
            }

            it("should return a network error if verification confirmation failed") {
                networkService.onDataRequest = { route in
                    return (nil, MBError(description: "mock error", type: MBErrorType.http(.internalServerError(data: nil))))
                }
                
                let model = UserVerificationConfirmationModel(code: "G-123456", type: .mobilePhoneNumber, subject: "+49123456789")
                
                userVerificationProvider.confirmUserVerification(userVerificationConfirmationModel: model) { (result) in
                    switch result {
                    case .failure(let error):
                        expect(error).to(matchError(UserVerificationServiceError.networkError))
                    case .success:
                        fail()
                    }
                }
            }
            
            it("should return a wrong confirmation code error if verification confirmation failed") {
                let returnedError = UserVerificationServiceError.wrongConfirmationCode
                networkService.onDataRequest = { route in
                    return (nil, MBError(description: "mock error", type: MBErrorType.http(.forbidden(data: nil))))
                }

                let model = UserVerificationConfirmationModel(code: "G-123456", type: .mobilePhoneNumber, subject: "+49123456789")
                
                userVerificationProvider.confirmUserVerification(userVerificationConfirmationModel: model) { (result) in
                    switch result {
                    case .failure(let error):
                        expect(error).to(matchError(returnedError))
                    case .success:
                        fail()
                    }
                }
            }
        }
    }
    
}
