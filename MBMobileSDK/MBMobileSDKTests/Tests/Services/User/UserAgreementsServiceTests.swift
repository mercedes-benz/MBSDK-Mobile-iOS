//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Quick
import Nimble

import MBNetworkKit

@testable import MBMobileSDK

public class UserAgreementsServiceTests: QuickSpec {
    
    public override func spec() {
        
        var service: UserAgreementsService!
        
        var mockTokenProviding: MockTokenProviding!
        var mockNetworking: MockNetworking!
        var mockJsonConverter: MockJsonConvertible!
        
        beforeEach {
            mockTokenProviding = MockTokenProviding()
            mockNetworking = MockNetworking()
            mockJsonConverter = MockJsonConvertible()
            
            service = UserAgreementsService(tokenProviding: mockTokenProviding,
                                            userService: MockUserServiceFunctions(),
                                            networking: mockNetworking,
                                            jsonConverter: mockJsonConverter,
                                            userRegionHelper: MockUserRegionHelping())
            
            mockTokenProviding.token = TokenTestHelper.token
        }
        
        describe("fetchAgreementsForCurrentUser") {
            it("should successfully fetch the agreements for the current user") {

                mockNetworking.onRequest = { route in
                    guard case BffAgreementRouter.get(let accessToken, let countryCode, let locale, let checkForNewVersion) = route else {
                        fail()
                        return (nil, nil)
                    }

                    expect(locale) == "rd_UIA"
                    expect(countryCode) == "UI"
                    expect(checkForNewVersion) == false
                    expect(accessToken) == "aToken"

                    return (self.dummyAPIAgreementsModel(), nil)
                }

                service.fetchAgreementsForCurrentUser() { result in
                    switch result {
                    case .success(let model):
                        expect(model.ciam).to(beEmpty())
                        expect(model.custom).to(beEmpty())
                        expect(model.ldsso).toNot(beEmpty())
                        expect(model.soe).to(beEmpty())
                        expect(model.toas?.checkboxes).to(beEmpty())
                        expect(model.toas?.documents).to(beEmpty())
                        expect(model.natCon).to(beNil())
                    case .failure: fail()
                    }
                }
            }
        }
        
        describe("fetchAgreements") {
            it("should successfully fetch the agreements for the given countryCode and locale") {
                // fake login to fail -  we dont need a token and want to make sure that we dont
                // accidently try to refresh a token anyway
                mockTokenProviding.token = nil
                
                mockNetworking.onRequest = { route in
                    guard case BffAgreementRouter.get(let accessToken, let countryCode, let locale, let checkForNewVersion) = route else {
                        fail()
                        return (nil, nil)
                    }
                    
                    expect(locale) == "de_DE"
                    expect(countryCode) == "DE"
                    expect(checkForNewVersion) == false
                    expect(accessToken).to(beNil())

                    return (self.dummyAPIAgreementsModel(), nil)

                }
                
                service.fetchAgreements(forCountryCode: "DE", locale: "de_DE") { result in
                    switch result {
                        case .success(let model):
                            expect(model.ciam).to(beEmpty())
                            expect(model.custom).to(beEmpty())
                            expect(model.ldsso).toNot(beEmpty())
                            expect(model.soe).to(beEmpty())
                            expect(model.toas?.checkboxes).to(beEmpty())
                            expect(model.toas?.documents).to(beEmpty())
                            expect(model.natCon).to(beNil())
                        case .failure: fail()
                    }
                }
            }
        }
        
        describe("checkAgreementsUpdateStatusForCurrentUser") {
            it("should successfully fetch the agreements update status for the current user") {

                mockNetworking.onRequest = { route in
                    guard case BffAgreementRouter.get(let accessToken, let countryCode, let locale, let checkForNewVersion) = route else {
                        fail()
                        return (nil, nil)
                    }
                    
                    expect(locale) == "rd_UIA"
                    expect(countryCode) == "UI"
                    expect(checkForNewVersion) == true
                    expect(accessToken) == "aToken"
                    
                    return (self.dummyAPIAgreementsModel(), nil)
                }
                
                service.checkAgreementsUpdateStatusForCurrentUser() { result in
                    switch result {
                    case .success(let model):
                        expect(model.ciam).to(beEmpty())
                        expect(model.custom).to(beEmpty())
                        expect(model.ldsso).toNot(beEmpty())
                        expect(model.soe).to(beEmpty())
                        expect(model.toas?.checkboxes).to(beEmpty())
                        expect(model.toas?.documents).to(beEmpty())
                        expect(model.natCon).to(beNil())
                    case .failure: fail()
                    }
                }
            }
        }
        
        describe("submitForCurrentUser") {
            it("should submit the agreements for the current user") {
                mockJsonConverter.jsonResult = ["agreement": "123"]
                
                mockNetworking.onRequest = { route in
                    guard case BffAgreementRouter.update(let accessToken, let locale, let requestModel) = route else {
                        fail()
                        return (nil, nil)
                    }
                    
                    expect(locale) == "rd_UIA"
                    expect(accessToken) == "aToken"
                    expect(requestModel?["agreement"] as? String) == "123"

                    return (self.dummyAPIAgreementsPartialContentModel(), nil)
                }
                
                service.submitForCurrentUser(agreements: self.dummyAgreementsSubmitModel()) { result in
                    switch result {
                    case .success(let model):
                        expect(model?.soeLegalTextsAcceptanceState?.allSubmitsHaveFailed) == true
                        expect(model?.soeLegalTextsAcceptanceState?.errorCode) == SubmitTermsOfUseError.userAgreementNotFound
                    case .failure: fail()
                    }
                }
            }
            
        }
        
        describe("submitForCurrentUser with HTTP 204") {
            it("should submit the agreements for the current user") {
                mockJsonConverter.jsonResult = ["agreement": "123"]
                
                mockNetworking.onRequest = { route in
                    guard case BffAgreementRouter.update(let accessToken, let locale, let requestModel) = route else {
                        fail()
                        return (nil, nil)
                    }
                    
                    expect(locale) == "rd_UIA"
                    expect(accessToken) == "aToken"
                    expect(requestModel?["agreement"] as? String) == "123"

                    return (nil, nil)
                }
                
                service.submitForCurrentUser(agreements: self.dummyAgreementsSubmitModel()) { result in
                    switch result {
                    case .success(let model):
                        expect(model).to(beNil())
                    case .failure: fail()
                    }
                }
            }
            
        }
    }
    
    private func dummyAPIAgreementsPartialContentModel() -> APIAgreementsPartialContentModel {
        return APIAgreementsPartialContentModel(ciamLegalTextsAcceptanceState: nil,
                                                customLegalTextsAcceptanceState: nil,
                                                ldssoLegalTextsAcceptanceState: nil,
                                                natconLegalTextsAcceptanceState: nil,
                                                soeLegalTextsAcceptanceState: APIAgreementPartialContentItemModel(allSubmitsHaveFailed: true, errorCode: "USER_AGREEMENT_NOT_FOUND_ERROR", userAgreementIDsOfUnsuccessfullySetApprovals: nil),
                                                toasLegalTextsAcceptanceState: nil)
    }
    
    private func dummyAgreementsSubmitModel() -> AgreementsSubmitModel {
        return AgreementsSubmitModel(customLegalTexts: [],
                                     natconLegalTexts: [],
                                     soeLegalTexts: [],
                                     ciamLegalTexts: [],
                                     ldssoLegalTexts: [])
    }
    
    private func dummyAPIAgreementsModel() -> APIAgreementsModel {
        return APIAgreementsModel(ciam: nil, custom: nil, errors: nil, ldsso: [APILdssoAgreementModel(documentID: "foo", locale: "xx-yy", version: String(), position: 0, displayName: "foo bar", implicitConsent: true, href: String(), acceptanceState: .accepted)], soe: nil, toas: nil, natCon: nil)
    }
    
    private func dummyAPIAgreementModels() -> [APIAgreementModel] {
        return [
            APIAgreementModel(documentData: "documentData1",
                              documents: [APIAgreementDocModel(acceptedByUser: true,
                                                               acceptedLocale: "acceptedLocale",
                                                               documentId: "documentId1",
                                                               version: 1)]),
            APIAgreementModel(documentData: "documentData2",
                              documents: [APIAgreementDocModel(acceptedByUser: true,
                                                               acceptedLocale: "acceptedLocale",
                                                               documentId: "documentId2",
                                                               version: 1)]),
            APIAgreementModel(documentData: "documentData3",
                              documents: [APIAgreementDocModel(acceptedByUser: true,
                                                               acceptedLocale: "acceptedLocale",
                                                               documentId: "documentId3",
                                                               version: 1)])
        ]
    }
    
    private class MockUserServiceFunctions: UserServiceRepresentable {
        var currentUser: UserModel? = nil
        
        func upload(profileImageData: Data, completion: @escaping (Result<Void, UserServiceError>) -> Void) {
            
        }
        
        func fetchProfileFields(countryCode: String, locale: String, completion: @escaping ((Result<[ProfileFieldModel], UserServiceError>) -> Void)) {
            
        }
        
        func fetch(completion: @escaping (Result<UserModel, UserServiceError>) -> Void) {}
    }
    
    private class MockUserRegionHelping: UserRegionHelping {
        func locale(for user: UserModel?) -> String {
            return "rd_UIA"
        }
        
        func countryCode(for user: UserModel?) -> String {
            return "UI"
        }
    }
}
