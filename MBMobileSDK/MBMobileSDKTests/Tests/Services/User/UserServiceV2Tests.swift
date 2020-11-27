//
//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Quick
import Nimble
import Foundation
import MBCommonKit
@testable import MBMobileSDK
@testable import MBNetworkKit


class UserServiceTests: QuickSpec {
        
    override func spec() {
        
        var dbStoreMock: MockDBStore!
        var tokenProviding: MockTokenProviding!
        var tokenStore: MockTokenStore!
        var networking: MockNetworking!
        var notificationSending: MockNotificationSending!
        var jsonConvertible: JsonConvertible!
        var nonceHelping: MockNonceHelper!
        var nonceStore: MockNonceStore!
        var subject: UserServiceRepresentable!
        
        beforeEach {
            dbStoreMock = MockDBStore()
            tokenProviding = MockTokenProviding()
            tokenStore = MockTokenStore()
            networking = MockNetworking()
            notificationSending = MockNotificationSending()
            jsonConvertible = JsonConverter()
            nonceHelping = MockNonceHelper()
            nonceStore = MockNonceStore()
            
            subject = UserService(dbStore: dbStoreMock, tokenProviding: tokenProviding, tokenStore: tokenStore, networking: networking, notificationSending: notificationSending, jsonConverter: jsonConvertible, nonceStore: nonceStore, nonceHelper: nonceHelping)
        }
        
        context("currentUser") {
            describe("when db store has no current user") {
                it("should return nil") {
                    dbStoreMock.currentUser = nil

                    expect(subject.currentUser).to(beNil())
                }
            }

            describe("when db store has a current user") {
                it("should return the same user") {
                    let user = UserModelHelper.build()
                    dbStoreMock.currentUser = user

                    expect(subject.currentUser).to(equal(user))
                }
            }
        }

        context("fetch user") {
            describe("when token refresh returns with failure") {
                it("should return with a failure") {
                    tokenProviding.token = nil

                    subject.fetch { result in
                        switch result {
                        case .success(_):
                            fail()
                        case .failure(let error):
                            switch error {
                            case .token:
                                success()
                            default:
                                fail()
                            }
                        }

                    }
                }
            }

            describe("when network request fails with network error") {
                it("should return with the appropriate error") {

                    let networkError = MBError(description: nil, type: MBErrorType.network(.timeOut(description: nil)))
                    let mockedReturn: ((EndpointRouter) -> (model: APIUserModel?, error: MBError?)) = { _ in (nil, networkError) }
                    networking.onRequest = mockedReturn

                    subject.fetch { result in
                        switch result {
                        case .success:
                            fail()
                        case .failure(let error):
                            switch error {
                            case .network(let wrappedError):
                                if let castedError = wrappedError {
                                    expect(castedError).to(equal(networkError))
                                } else {
                                    fail()
                                }
                            default:
                                fail()
                            }
                        }
                    }
                }
            }

            describe("when saving to db fails") {
                it("should return with the appropriate error") {
                    let mockedReturn: ((EndpointRouter) -> (model: APIUserModel?, error: MBError?)) = { _ in (APIUserModel.create(), nil) }
                    networking.onRequest = mockedReturn
                    dbStoreMock.saveResult = .failure(.unknown)

                    subject.fetch { result in
                        switch result {
                        case .success:
                            fail()
                        case .failure(let error):
                            switch error {
                            case .savingUserToStore:
                                success()
                            default:
                                fail()
                            }
                        }
                    }
                }
            }

            describe("when saving the same new user to db succeeds") {
                it("should return successfully and send a notification") {
                    let apiUser = APIUserModel.create(accountCountryCode: "newCountry", preferredLanguageCode: "newLanguage")
                    let mockedReturn: ((EndpointRouter) -> (model: APIUserModel?, error: MBError?)) = { _ in (apiUser, nil) }
                    networking.onRequest = mockedReturn
                    
                    // generate the mock current user using the same api user.
                    let mockUserModel = NetworkModelMapper.map(apiUser: apiUser)
                    
                    dbStoreMock.currentUser = mockUserModel
                    dbStoreMock.saveResult = .success(mockUserModel)
                    
                    subject.fetch { result in
                        switch result {
                            case .success(let user):
                                expect(notificationSending.isSentDidUpdateUserRegionLanguage) == false
                                expect(notificationSending.updatedUser).to(beNil())
                                expect(user).to(equal(mockUserModel))
                            case .failure:
                                fail()
                        }
                    }
                }
            }
            
            describe("when saving a different new user to db succeeds") {
                it("should return successfully and send a notification") {
                    let apiUser = APIUserModel.create(accountCountryCode: "newCountry", preferredLanguageCode: "newLanguage")
                    let mockedReturn: ((EndpointRouter) -> (model: APIUserModel?, error: MBError?)) = { _ in (apiUser, nil) }
                    networking.onRequest = mockedReturn

                    let mockCurrentUserModel = UserModel.create()
                    dbStoreMock.currentUser = mockCurrentUserModel

                    let returnedUserModel = NetworkModelMapper.map(apiUser: apiUser)
                    dbStoreMock.saveResult = .success(returnedUserModel)

                    subject.fetch { result in
                        switch result {
                            case .success(let user):
                                expect(notificationSending.isSentDidUpdateUserRegionLanguage) == true
                                expect(notificationSending.updatedUser).to(equal(returnedUserModel))
                                expect(user).to(equal(returnedUserModel))
                            case .failure:
                                fail()
                        }
                    }
                }
            }

            describe("when current user had profileImageData") {
                it("should return a user successfully with the same profileImageData") {
                    let apiUser = APIUserModel.create(ciamId: "asd", firstName: "Ronny")
                    let mockedReturn: ((EndpointRouter) -> (model: APIUserModel?, error: MBError?)) = { _ in (apiUser, nil) }
                    networking.onRequest = mockedReturn

                    let currentUser = UserModel.create(ciamId: "asd", firstName: "Ronny2", profileImageData: Data())
                    dbStoreMock.currentUser = currentUser

                    let returnedUserModel = UserModel.create(ciamId: "asd", firstName: "Ronny", profileImageData: Data())
                    dbStoreMock.saveResult = .success(returnedUserModel) // just that dbStore mock returns .success, will be ignored

                    expect(currentUser.profileImageData).toNot(beNil())
                    subject.fetch { result in
                        switch result {
                        case .success:
                            expect(dbStoreMock.userToBeSaved?.profileImageData).toNot(beNil())
                            expect(dbStoreMock.userToBeSaved?.profileImageData).to(equal(Data()))
                        case .failure:
                            fail()
                        }
                    }
                }
            }

            describe("when current user had profileImageData but had different ciam id") {
                it("should return a user successfully but without profileImageData") {
                    let apiUser = APIUserModel.create(ciamId: "asd", firstName: "Ronny")
                    let mockedReturn: ((EndpointRouter) -> (model: APIUserModel?, error: MBError?)) = { _ in (apiUser, nil) }
                    networking.onRequest = mockedReturn

                    let currentUser = UserModel.create(ciamId: "asdf", firstName: "Ronny2", profileImageData: Data())
                    dbStoreMock.currentUser = currentUser

                    let returnedUserModel = UserModel.create(ciamId: "asd", firstName: "Ronny", profileImageData: Data())
                    dbStoreMock.saveResult = .success(returnedUserModel) // just that dbStore mock returns .success, will be ignored

                    expect(currentUser.profileImageData).toNot(beNil())
                    subject.fetch { result in
                        switch result {
                        case .success:
                            expect(dbStoreMock.userToBeSaved?.profileImageData).to(beNil())
                        case .failure:
                            fail()
                        }
                    }
                }
            }

            describe("when current user had profileImageEtag") {
                it("should return a user successfully with the same profileImageEtag") {
                    let apiUser = APIUserModel.create(ciamId: "asd", firstName: "Ronny")
                    let mockedReturn: ((EndpointRouter) -> (model: APIUserModel?, error: MBError?)) = { _ in (apiUser, nil) }
                    networking.onRequest = mockedReturn

                    let currentUser = UserModel.create(ciamId: "asd", firstName: "Ronny2", profileImageEtag: "0xasd")
                    dbStoreMock.currentUser = currentUser

                    let returnedUserModel = UserModel.create(ciamId: "asd", firstName: "Ronny", profileImageEtag: "0xasd")
                    dbStoreMock.saveResult = .success(returnedUserModel) // just that dbStore mock returns .success, will be ignored

                    expect(currentUser.profileImageEtag).toNot(beNil())
                    subject.fetch { result in
                        switch result {
                        case .success:
                            expect(dbStoreMock.userToBeSaved?.profileImageEtag).toNot(beNil())
                            expect(dbStoreMock.userToBeSaved?.profileImageEtag).to(equal("0xasd"))
                        case .failure:
                            fail()
                        }
                    }
                }
            }

            describe("when current user had profileImageEtag but had different ciam id") {
                it("should return a user successfully but without profileImageEtag") {
                    let apiUser = APIUserModel.create(ciamId: "asd", firstName: "Ronny")
                    let mockedReturn: ((EndpointRouter) -> (model: APIUserModel?, error: MBError?)) = { _ in (apiUser, nil) }
                    networking.onRequest = mockedReturn

                    let currentUser = UserModel.create(ciamId: "asdf", firstName: "Ronny2", profileImageEtag: "0xasd")
                    dbStoreMock.currentUser = currentUser

                    let returnedUserModel = UserModel.create(ciamId: "asd", firstName: "Ronny", profileImageEtag: "0xasd")
                    dbStoreMock.saveResult = .success(returnedUserModel) // just that dbStore mock returns .success, will be ignored

                    expect(currentUser.profileImageEtag).toNot(beNil())
                    subject.fetch { result in
                        switch result {
                        case .success:
                            expect(dbStoreMock.userToBeSaved?.profileImageEtag).to(beNil())
                        case .failure:
                            fail()
                        }
                    }
                }
            }
        }

        context("delete user") {
            describe("when token refresh returns with failure") {
                it("should return with a failure") {
                    tokenProviding.token = nil

                    subject.delete { result in
                        switch result {
                        case .success(_):
                            fail()
                        case .failure(let error):
                            switch error {
                            case .token:
                                success()
                            default:
                                fail()
                            }
                        }

                    }
                }
            }

            describe("when network request fails with network error") {
                it("should return with the appropriate error") {

                    let networkError = MBError(description: nil, type: MBErrorType.network(.timeOut(description: nil)))
                    let mockedReturn: ((EndpointRouter) -> (model: APIUserModel?, error: MBError?)) = { _ in (nil, networkError) }
                    networking.onRequest = mockedReturn

                    subject.delete { result in
                        switch result {
                        case .success:
                            fail()
                        case .failure(let error):
                            switch error {
                            case .network(let wrappedError):
                                if let castedError = wrappedError {
                                    expect(castedError).to(equal(networkError))
                                } else {
                                    fail()
                                }
                            default:
                                fail()
                            }
                        }
                    }
                }
            }

            describe("when deleting user from db fails") {
                it("should return with the appropriate error") {
                    let mockedReturn: ((EndpointRouter) -> (model: APIUserModel?, error: MBError?)) = { _ in (APIUserModel.create(), nil) }
                    networking.onRequest = mockedReturn
                    dbStoreMock.deleteResult = .failure(.dbError)

                    subject.delete { result in
                        switch result {
                        case .success:
                            fail()
                        case .failure(let error):
                            switch error {
                            case .deletingUserFromStore:
                                success()
                            default:
                                fail()
                            }
                        }
                    }
                }
            }
        }

        context("create user") {

            describe("when network request fails with network error") {
                it("should return with the appropriate error") {

                    let networkError = MBError(description: nil, type: MBErrorType.network(.timeOut(description: nil)))
                    let mockedReturn: ((EndpointRouter) -> (model: APIRegistrationUserModel?, error: MBError?)) = { _ in (nil, networkError) }
                    networking.onRequest = mockedReturn
                    
                    expect(nonceStore.nonce()).to(beNil())

                    subject.create(user: UserModel.create()) { result in
                        
                        expect(nonceStore.nonce()).to(equal(MockNonceHelper.nonce))
                        
                        switch result {
                        case .success:
                            fail()
                        case .failure(let error):
                            switch error {
                            case .registration:
                                success()
                            default:
                                fail()
                            }
                        }
                    }
                }
            }

			describe("when http request fails with 502 bad gateway") {
                it("should return with the error `.toasNotReached`") {

					let networkError = MBError(description: nil, type: MBErrorType.http(.badGateway(data: nil)))
                    let mockedReturn: ((EndpointRouter) -> (model: APIRegistrationUserModel?, error: MBError?)) = { _ in (nil, networkError) }
                    networking.onRequest = mockedReturn
                    
                    expect(nonceStore.nonce()).to(beNil())

                    subject.create(user: UserModel.create()) { result in
                        
                        expect(nonceStore.nonce()).to(equal(MockNonceHelper.nonce))
                        
                        switch result {
                        case .success:
                            fail()
                        case .failure(let error):
                            switch error {
                            case .toasNotReached:
                                success()
                            default:
                                fail()
                            }
                        }
                    }
                }
            }

            describe("when network request succeeds") {
                it("should return successfully") {
                    let mockedReturn: ((EndpointRouter) -> (model: APIRegistrationUserModel?, error: MBError?)) = { _ in (APIRegistrationUserModel.create(communicationPreference: nil), nil) }
                    networking.onRequest = mockedReturn
                    dbStoreMock.saveResult = .failure(.unknown)
                    
                    expect(nonceStore.nonce()).to(beNil())

                    subject.create(user: UserModel.create()) { result in
                        
                        expect(nonceStore.nonce()).to(equal(MockNonceHelper.nonce))
                        
                        switch result {
                        case .success:
                            success()
                        case .failure:
                            fail()
                        }
                    }
                }
            }
        }

        context("update user") {
            describe("when token refresh returns with failure") {
                it("should return with a failure") {
                    tokenProviding.token = nil

                    subject.update(user: UserModel.create()) { result in
                        switch result {
                        case .success(_):
                            fail()
                        case .failure(let error):
                            switch error {
                            case .token:
                                success()
                            default:
                                fail()
                            }
                        }

                    }
                }
            }

            describe("when network request fails with network error") {
                it("should return with the appropriate error") {

                    let networkError = MBError(description: nil, type: MBErrorType.network(.timeOut(description: nil)))
                    networking.onDataRequest = { _ in (nil, networkError) }

                    subject.update(user: UserModel.create()) { result in
                        switch result {
                        case .success:
                            fail()
                        case .failure(let error):
                            expect(error).to(matchError(UserServiceError.registration(RegistrationError(description: nil, errors: []))))
                        }
                    }
                }
            }

            describe("when saving user to db fails") {
                it("should return with the appropriate error") {
                    networking.onDataRequest = { _ in (Data(), nil) }
                    dbStoreMock.saveResult = .failure(.unknown)

                    subject.update(user: UserModel.create()) { result in
                        switch result {
                        case .success:
                            fail()
                        case .failure(let error):
                            switch error {
                            case .savingUserToStore:
                                success()
                            default:
                                fail()
                            }
                        }
                    }
                }
            }

            describe("when saving user to db succeeds") {
                it("should return successfully") {
                    networking.onDataRequest = { _ in (Data(), nil) }

                    let returnedUserModel = UserModel.create()
                    dbStoreMock.saveResult = .success(returnedUserModel)

                    subject.update(user: UserModel.create()) { result in
                        switch result {
                        case .failure:
                            fail()
                        case .success:
                            success()
                        }
                    }
                }
            }
        }

        context("update unit preferences") {
            describe("when token refresh returns with failure") {
                it("should return with a failure") {
                    tokenProviding.token = nil

                    subject.update(unitPreference: UserUnitPreferenceModel.create()) { result in
                        switch result {
                        case .success(_):
                            fail()
                        case .failure(let error):
                            switch error {
                            case .token:
                                success()
                            default:
                                fail()
                            }
                        }

                    }
                }
            }

            describe("when network request fails with network error") {
                it("should return with the appropriate error") {

                    let networkError = MBError(description: nil, type: MBErrorType.network(.timeOut(description: nil)))
                    let mockedReturn: ((EndpointRouter) -> (model: APIUserModel?, error: MBError?)) = { _ in (nil, networkError) }
                    networking.onRequest = mockedReturn

                    subject.update(unitPreference: UserUnitPreferenceModel.create()) { result in
                        switch result {
                        case .success:
                            fail()
                        case .failure(let error):
                            switch error {
                            case .network(let wrappedError):
                                if let castedError = wrappedError {
                                    expect(castedError).to(equal(networkError))
                                } else {
                                    fail()
                                }
                            default:
                                fail()
                            }
                        }
                    }
                }
            }

            describe("when fetching user from store fails") {
                it("should return with the appropriate error") {
                    let mockedReturn: ((EndpointRouter) -> (model: APIUserModel?, error: MBError?)) = { _ in (APIUserModel.create(), nil) }
                    networking.onRequest = mockedReturn
                    dbStoreMock.saveResult = .failure(.unknown)

                    subject.update(unitPreference: UserUnitPreferenceModel.create()) { result in
                        switch result {
                        case .success:
                            fail()
                        case .failure(let error):
                            switch error {
                            case .fetchingUserFromStore:
                                success()
                            default:
                                fail()
                            }
                        }
                    }
                }
            }

            describe("when saving user to db fails") {
                it("should return with the appropriate error") {
                    let mockedReturn: ((EndpointRouter) -> (model: APIUserModel?, error: MBError?)) = { _ in (APIUserModel.create(), nil) }
                    networking.onRequest = mockedReturn
                    dbStoreMock.currentUser = UserModel.create()
                    dbStoreMock.saveResult = .failure(.unknown)

                    subject.update(unitPreference: UserUnitPreferenceModel.create()) { result in
                        switch result {
                        case .success:
                            fail()
                        case .failure(let error):
                            switch error {
                            case .savingUserToStore:
                                success()
                            default:
                                fail()
                            }
                        }
                    }
                }
            }

            describe("when saving user to db succeeds") {
                it("should return successfully") {
                    let mockedReturn: ((EndpointRouter) -> (model: APIUserModel?, error: MBError?)) = { _ in (APIUserModel.create(), nil) }
                    networking.onRequest = mockedReturn

                    dbStoreMock.currentUser = UserModel.create(unitPreferences: UserUnitPreferenceModel(clockHours: .type24h))

                    let preferences = UserUnitPreferenceModel(clockHours: .type12h)
                    let returnedUserModel = UserModel.create(unitPreferences: UserUnitPreferenceModel(clockHours: .type12h))
                    dbStoreMock.saveResult = .success(returnedUserModel)

                    subject.update(unitPreference: preferences) { result in
                        switch result {
                        case .failure:
                            fail()
                        case .success(let user):
                            expect(user.unitPreferences).to(equal(preferences))
                        }
                    }
                }
            }
        }

        context("update adaption values") {
            describe("when token refresh returns with failure") {
                it("should return with a failure") {
                    tokenProviding.token = nil

                    subject.update(adaptionValues: UserAdaptionValuesModel(bodyHeight: nil, preAdjustment: nil, alias: nil)) { result in
                        switch result {
                        case .success(_):
                            fail()
                        case .failure(let error):
                            switch error {
                            case .token:
                                success()
                            default:
                                fail()
                            }
                        }

                    }
                }
            }

            describe("when network request fails with network error") {
                it("should return with the appropriate error") {

                    let networkError = MBError(description: nil, type: MBErrorType.network(.timeOut(description: nil)))
                    networking.onDataRequest = { _ in (nil, networkError) }

                    subject.update(adaptionValues: UserAdaptionValuesModel(bodyHeight: nil, preAdjustment: nil, alias: nil)) { result in
                        switch result {
                        case .success:
                            fail()
                        case .failure(let error):
                            switch error {
                            case .network(let wrappedError):
                                if let castedError = wrappedError {
                                    expect(castedError).to(equal(networkError))
                                } else {
                                    fail()
                                }
                            default:
                                fail()
                            }
                        }
                    }
                }
            }

            context("store interactions") {
                beforeEach {
                    networking.onDataRequest = { _ in (Data(), nil) }
                }

                describe("when fetching user from store fails") {
                    it("should return with the appropriate error") {
                        dbStoreMock.saveResult = .failure(.unknown)

                        subject.update(adaptionValues: UserAdaptionValuesModel(bodyHeight: nil, preAdjustment: nil, alias: nil)) { result in
                            switch result {
                            case .success:
                                fail()
                            case .failure(let error):
                                switch error {
                                case .fetchingUserFromStore:
                                    success()
                                default:
                                    fail()
                                }
                            }
                        }
                    }
                }

                describe("when saving user to db fails") {
                    it("should return with the appropriate error") {
                        dbStoreMock.currentUser = UserModel.create()
                        dbStoreMock.saveResult = .failure(.unknown)

                        subject.update(adaptionValues: UserAdaptionValuesModel(bodyHeight: nil, preAdjustment: nil, alias: nil)) { result in
                            switch result {
                            case .success:
                                fail()
                            case .failure(let error):
                                switch error {
                                case .savingUserToStore:
                                    success()
                                default:
                                    fail()
                                }
                            }
                        }
                    }
                }

                describe("when saving user to db succeeds") {
                    it("should return successfully") {
                        dbStoreMock.currentUser = UserModel.create()

                        let adaptionValues = UserAdaptionValuesModel(bodyHeight: 154, preAdjustment: nil, alias: nil)
                        let returnedUserModel = UserModel.create(adaptionValues: adaptionValues)
                        dbStoreMock.saveResult = .success(returnedUserModel)

                        subject.update(adaptionValues: adaptionValues) { result in
                            switch result {
                            case .failure:
                                fail()
                            case .success(let user):
                                expect(user.adaptionValues).to(equal(adaptionValues))
                            }
                        }
                    }
                }
            }
        }

        context("upload profile image") {
            beforeEach {
                IngressKit.bffProvider = BffProviderMock(sdkVersion: "1.42")
            }

            describe("when token refresh returns with failure") {
                it("should return with a failure") {
                    tokenProviding.token = nil

                    subject.upload(profileImageData: Data()) { result in
                        switch result {
                        case .success(_):
                            fail()
                        case .failure(let error):
                            switch error {
                            case .token:
                                success()
                            default:
                                fail()
                            }
                        }

                    }
                }
            }

            describe("when network request fails with network error") {
                it("should return with the appropriate error") {

                    let networkError = MBError(description: nil, type: MBErrorType.network(.timeOut(description: nil)))
                    networking.onUpload = .failure(networkError)

                    subject.upload(profileImageData: Data()) { result in
                        switch result {
                        case .success:
                            fail()
                        case .failure(let error):
                            switch error {
                            case .network(let wrappedError):
                                if let castedError = wrappedError {
                                    expect(castedError).to(equal(networkError))
                                } else {
                                    fail()
                                }
                            default:
                                fail()
                            }
                        }
                    }
                }
            }

            describe("when fetching user from store fails") {
                it("should return with the appropriate error") {
                    networking.onUpload = .success(())
                    dbStoreMock.saveResult = .failure(.unknown)

                    subject.upload(profileImageData: Data()) { result in
                        switch result {
                        case .success:
                            fail()
                        case .failure(let error):
                            switch error {
                            case .fetchingUserFromStore:
                                success()
                            default:
                                print(error)
                                fail()
                            }
                        }
                    }
                }
            }

            describe("when saving user to db fails") {
                it("should return with the appropriate error") {
                    networking.onUpload = .success(())
                    dbStoreMock.currentUser = UserModel.create()
                    dbStoreMock.saveResult = .failure(.unknown)

                    subject.upload(profileImageData: Data()) { result in
                        switch result {
                        case .success:
                            fail()
                        case .failure(let error):
                            switch error {
                            case .savingUserToStore:
                                success()
                            default:
                                fail()
                            }
                        }
                    }
                }
            }

            describe("when saving user to db succeeds") {
                it("should return successfully") {
                    networking.onUpload = .success(())

                    dbStoreMock.currentUser = UserModel.create()

                    let profileImageData = Data()
                    let returnedUserModel = UserModel.create(profileImageData: profileImageData)
                    dbStoreMock.saveResult = .success(returnedUserModel)

                    subject.upload(profileImageData: profileImageData) { result in
                        switch result {
                        case .failure:
                            fail()
                        case .success:
                            success()
                        }
                    }
                }
            }
        }
    }
}

class MockDBStore: UserDbStoreRepresentable {
    
    var saveResult: Result<UserModel, UserDbStoreError>?
    var deleteResult: Result<Void, UserDbStoreError>?
    
    var userToBeSaved: UserModel?
    
    var currentUser: UserModel?
    
    func save(user: UserModel, completion: @escaping ((Result<UserModel, UserDbStoreError>) -> Void)) {
        self.userToBeSaved = user
        
        if let saveResult = saveResult {
            completion(saveResult)
        } else {
            completion(.failure(.unknown))
        }
    }
    
    func deleteCurrentUser(completion: @escaping ((Result<Void, UserDbStoreError>) -> Void)) {
        if let deleteResult = deleteResult {
            completion(deleteResult)
        } else {
            completion(.failure(.unknown))
        }
    }
    
    
}

class MockNotificationSending: NotificationSending {
    
    var isSentDidUpdateUserRegionLanguage = false
    var updatedUser: UserModel?
    
    func sendDidUpdateUserNotification(_ user: UserModel?, isNewUser: Bool) {
       
    }
    
    func sendDidUpdateUserRegionLanguage(_ user: UserModel?) {
        updatedUser = user
        isSentDidUpdateUserRegionLanguage = true
    }
    
}

class MockTokenProviding: TokenProviding {
    
    var token: Token? = TokenTestHelper.token
    
    required init() {}
    
    func refreshTokenIfNeeded(completion: @escaping (Result<TokenConformable, TokenProvidingError>) -> Void) {
        if let token = token {
            completion(.success(token))
        } else {
            completion(.failure(.tokenRefreshFailed))
        }
    }
    
    func requestToken(onComplete: @escaping (TokenConformable) -> Void) {
        if let token = token {
            onComplete(token)
        }
    }
    
}

class MockNonceStore: NonceRepository {
    
    var returnedNonce: String?
    
    func nonce() -> String? {
        return returnedNonce
    }
    
    func save(nonce: String?) {
        self.returnedNonce = nonce
    }
}
