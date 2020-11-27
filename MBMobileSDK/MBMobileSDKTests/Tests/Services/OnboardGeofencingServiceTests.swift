//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Nimble
import Quick

import MBCommonKit
import MBNetworkKit

@testable import MBMobileSDK

class OnboardGeofencingServiceTests: QuickSpec {
    
    override func spec() {
        var networkService: MockNetworkService!
        var loginService: MockLoginService!
        var onboardGeofencingService: OnboardGeofencingServiceRepresentable!
        
        beforeEach {
            networkService = MockNetworkService()
            loginService = MockLoginService()
            onboardGeofencingService = OnboardGeofencingService(networking: networkService,
                                                                loginService: loginService)
            
            loginService.onTokenRefresh = { ("accessToken", nil) }
        }
        
        context("CustomerFences") {
            describe("fetch CustomerFences") {
                it("should return success") {
                    let apiCustomerFenceModel = APICustomerFenceModel(customerfenceid: 1,
                                                                      geofenceid: 1,
                                                                      name: "CustomerFence",
                                                                      days: [.sunday],
                                                                      beginMinutes: 0,
                                                                      endMinutes: 10,
                                                                      ts: 100,
                                                                      violationtype: .leaveAndEnter)
                    
                    networkService.returnedDecodable = [apiCustomerFenceModel]
                    
                    onboardGeofencingService.fetchCustomerFences(finOrVin: "WDD1770871Z000099") { (result) in
                        switch result {
                        case .failure:
                            fail()
                        case .success(let models):
                            guard let model = models.first else {
                                fail()
                                return
                            }
                            
                            expect(model.customerfenceid)    == 1
                            expect(model.geofenceid)         == 1
                            expect(model.name)               == "CustomerFence"
                            expect(model.days)               == [.sunday]
                            expect(model.beginMinutes)       == 0
                            expect(model.endMinutes)         == 10
                            expect(model.timestamp)          == 100
                            expect(model.violationtype)      == .leaveAndEnter
                        }
                    }
                }
                it("should return error") {
                    networkService.returnedError = MBError(description: "mock error",
                                                           type: MBErrorType.http(.internalServerError(data: nil)))
                    
                    onboardGeofencingService.fetchCustomerFences(finOrVin: "WDD1770871Z000099") { (result) in
                        switch result {
                        case .failure(let error):
                            expect(error).to(matchError(OnboardGeofencingError.network))
                        case .success:
                            fail()
                        }
                    }
                }
            }
            
            describe("create CustomerFences") {
                let createModel = CustomerFenceModel.create(geofenceid: 1,
                                                                              name: "CustomerFence",
                                                                              days: [.sunday],
                                                                              beginMinutes: 0,
                                                                              endMinutes: 10,
                                                                              violationtype: .leaveAndEnter)
                
                
                it("should return success") {
                    
                    onboardGeofencingService.createCustomerFences(finOrVin: "WDD1770871Z000099", customerFences: [createModel]) { (result) in
                        switch result {
                        case .failure:
                            fail()
                        case .success:
                            _ = succeed()
                        }
                    }
                }
                
                it("should return error") {
                    networkService.returnedError = MBError(description: "mock error",
                                                           type: MBErrorType.http(.internalServerError(data: nil)))
                    
                    onboardGeofencingService.createCustomerFences(finOrVin: "WDD1770871Z000099", customerFences: [createModel]) { (result) in
                        switch result {
                        case .failure(let error):
                            expect(error).to(matchError(OnboardGeofencingError.network))
                        case .success:
                            fail()
                        }
                    }
                }
            }
            
            describe("update CustomerFences") {
                let updateModel = CustomerFenceModel.update(customerfenceid: 1,
                                                                              geofenceid: 1,
                                                                              name: "CustomerFence",
                                                                              days: [.sunday],
                                                                              beginMinutes: 0,
                                                                              endMinutes: 10,
                                                                              violationtype: .leave)
                
                it("should return success") {
                    
                    onboardGeofencingService.updateCustomerFences(finOrVin: "WDD1770871Z000099", customerFences: [updateModel]) { (result) in
                        switch result {
                        case .failure:
                            fail()
                        case .success:
                            _ = succeed()
                        }
                    }
                }
                it("should return error") {
                    networkService.returnedError = MBError(description: "mock error",
                                                           type: MBErrorType.http(.internalServerError(data: nil)))
                    
                    onboardGeofencingService.updateCustomerFences(finOrVin: "WDD1770871Z000099", customerFences: [updateModel]) { (result) in
                        switch result {
                        case .failure(let error):
                            expect(error).to(matchError(OnboardGeofencingError.network))
                        case .success:
                            fail()
                        }
                    }
                }
            }
            
            describe("delete CustomerFences") {
                let ids = [1, 2, 5]
                
                it("should return success") {
                    
                    onboardGeofencingService.deleteCustomerFences(finOrVin: "WDD1770871Z000099", ids: ids) { (result) in
                        switch result {
                        case .failure:
                            fail()
                        case .success:
                            _ = succeed()
                        }
                    }
                }
                it("should return error") {
                    networkService.returnedError = MBError(description: "mock error",
                                                           type: MBErrorType.http(.locked(data: nil)))
                    
                    onboardGeofencingService.deleteCustomerFences(finOrVin: "WDD1770871Z000099", ids: ids) { (result) in
                        switch result {
                        case .failure(let error):
                            expect(error).to(matchError(OnboardGeofencingError.commandInProgress))
                        case .success:
                            fail()
                        }
                    }
                }
            }
        }
        
        context("CustomerFences Violations") {
            describe("fetch CustomerFences Violations") {
                
                it("should return success") {
                    
                    let customerFence = APICustomerFenceModel(customerfenceid: 1,
                                                              geofenceid: 1,
                                                              name: "CustomerFence",
                                                              days: [.monday],
                                                              beginMinutes: 0,
                                                              endMinutes: 10,
                                                              ts: 100,
                                                              violationtype: .enter)
                    
                    let onboardFence = APIOnboardFenceModel(geofenceid: 1,
                                                            name: "OnboardFence",
                                                            isActive: true,
                                                            center: CoordinateModel.sindelfingen,
                                                            fencetype: .circle,
                                                            radiusInMeter: 200,
                                                            verticescount: 1,
                                                            verticespositions: [CoordinateModel.sindelfingen],
                                                            syncstatus: .finished)
                    
                    let violationModel = APICustomerFenceViolationModel(violationid: 1,
                                                                        time: 1,
                                                                        coordinates: CoordinateModel.sindelfingen,
                                                                        customerfence: customerFence,
                                                                        onboardfence: onboardFence)
                    
                    networkService.returnedDecodable = [violationModel]
                    
                    onboardGeofencingService.fetchCustomerFenceViolations(finOrVin: "WDD1770871Z000099") { (result) in
                        switch result {
                        case .failure:
                            fail()
                        case .success(let models):
                            guard let model = models.first else {
                                fail()
                                return
                            }
                            expect(model.violationid) == 1
                            expect(model.time) == 1
                            expect(model.coordinates) == CoordinateModel.sindelfingen
                            expect(model.coordinates?.longitude) == CoordinateModel.sindelfingen.longitude
                            expect(model.customerfence?.geofenceid) == 1
                            expect(model.customerfence?.customerfenceid) == 1
                            expect(model.onboardfence?.geofenceid) == 1
                            expect(model.onboardfence?.name) == "OnboardFence"
                        }
                    }
                }
                it("should return error") {
                    networkService.returnedError = MBError(description: "mock error",
                                                           type: MBErrorType.http(.internalServerError(data: nil)))
                    
                    onboardGeofencingService.fetchCustomerFenceViolations(finOrVin: "WDD1770871Z000099") { (result) in
                        switch result {
                        case .failure(let error):
                            expect(error).to(matchError(OnboardGeofencingError.network))
                        case .success:
                            fail()
                        }
                    }
                }
            }
            
            describe("delete CustomerFences Violations") {
                let ids = [1, 2, 5]
                
                it("should return success") {
                    
                    onboardGeofencingService.deleteCustomerFenceViolations(finOrVin: "WDD1770871Z000099", ids: ids) { (result) in
                        switch result {
                        case .failure:
                            fail()
                        case .success:
                            _ = succeed()
                        }
                    }
                }
                it("should return error") {
                    networkService.returnedError = MBError(description: "mock error",
                                                           type: MBErrorType.http(.locked(data: nil)))
                    
                    onboardGeofencingService.deleteCustomerFenceViolations(finOrVin: "WDD1770871Z000099", ids: ids) { (result) in
                        switch result {
                        case .failure(let error):
                            expect(error).to(matchError(OnboardGeofencingError.commandInProgress))
                        case .success:
                            fail()
                        }
                    }
                }
            }
        }
        
        context("OnboardFences") {
            describe("fetch OnboardFences") {
                it("should return success") {
                    let apiOnboardFenceModel = APIOnboardFenceModel(geofenceid: 1,
                                                                    name: "OnboardFence",
                                                                    isActive: true,
                                                                    center: CoordinateModel.sindelfingen,
                                                                    fencetype: .circle,
                                                                    radiusInMeter: 200,
                                                                    verticescount: 3,
                                                                    verticespositions: [CoordinateModel.sindelfingen],
                                                                    syncstatus: .finished)
                    
                    networkService.returnedDecodable = [apiOnboardFenceModel]
                    
                    onboardGeofencingService.fetchOnboardFences(finOrVin: "WDD1770871Z000099") { (result) in
                        switch result {
                        case .failure:
                            fail()
                        case .success(let models):
                            guard let model = models.first else {
                                fail()
                                return
                            }
                            
                            expect(model.geofenceid)         == 1
                            expect(model.name)               == "OnboardFence"
                            expect(model.isActive)           == true
                            expect(model.center?.latitude)   == CoordinateModel.sindelfingen.latitude
                            expect(model.center?.longitude)  == CoordinateModel.sindelfingen.longitude
                            expect(model.fencetype)          == .circle
                            expect(model.radiusInMeter)      == 200
                            expect(model.verticescount)      == 3
                            expect(model.syncstatus)         == .finished
                        }
                    }
                }
                it("should return error") {
                    networkService.returnedError = MBError(description: "mock error",
                                                           type: MBErrorType.http(.internalServerError(data: nil)))
                    
                    onboardGeofencingService.fetchCustomerFences(finOrVin: "WDD1770871Z000099") { (result) in
                        switch result {
                        case .failure(let error):
                            expect(error).to(matchError(OnboardGeofencingError.network))
                        case .success:
                            fail()
                        }
                    }
                }
            }
            
            describe("create OnboardFences") {
                let onboardFence = OnboardFenceModel.create(name: "OnboardFence",
                                                            isActive: true,
                                                            center: CoordinateModel.sindelfingen,
                                                            fencetype: .circle,
                                                            radiusInMeter: 400,
                                                            verticescount: 5,
                                                            verticespositions: [CoordinateModel.sindelfingen])
                
                
                it("should return success") {
                    
                    onboardGeofencingService.createOnboardFences(finOrVin: "WDD1770871Z000099", onboardFences: [onboardFence]) { (result) in
                        switch result {
                        case .failure:
                            fail()
                        case .success:
                            _ = succeed()
                        }
                    }
                }
                
                it("should return error") {
                    networkService.returnedError = MBError(description: "mock error",
                                                           type: MBErrorType.http(.internalServerError(data: nil)))
                    
                    onboardGeofencingService.createOnboardFences(finOrVin: "WDD1770871Z000099", onboardFences: [onboardFence]) { (result) in
                        switch result {
                        case .failure(let error):
                            expect(error).to(matchError(OnboardGeofencingError.network))
                        case .success:
                            fail()
                        }
                    }
                }
            }
            
            describe("update OnboardFences") {
                let onboardFence = OnboardFenceModel.update(geofenceid: 1,
                                                            name: "OnboardFence",
                                                            isActive: true,
                                                            center: CoordinateModel.sindelfingen,
                                                            fencetype: .circle,
                                                            radiusInMeter: 300,
                                                            verticescount: 3,
                                                            verticespositions: [CoordinateModel.sindelfingen])
                
                it("should return success") {
                    
                    onboardGeofencingService.updateOnboardFences(finOrVin: "WDD1770871Z000099", onboardFences: [onboardFence]) { (result) in
                        switch result {
                        case .failure:
                            fail()
                        case .success:
                            _ = succeed()
                        }
                    }
                }
                it("should return error") {
                    networkService.returnedError = MBError(description: "mock error",
                                                           type: MBErrorType.http(.internalServerError(data: nil)))
                    
                    onboardGeofencingService.updateOnboardFences(finOrVin: "WDD1770871Z000099", onboardFences: [onboardFence]) { (result) in
                        switch result {
                        case .failure(let error):
                            expect(error).to(matchError(OnboardGeofencingError.network))
                        case .success:
                            fail()
                        }
                    }
                }
            }
            
            describe("delete OnboardFences") {
                let ids = [1, 2, 5]
                
                it("should return success") {
                    
                    onboardGeofencingService.deleteOnboardFences(finOrVin: "WDD1770871Z000099", ids: ids) { (result) in
                        switch result {
                        case .failure:
                            fail()
                        case .success:
                            _ = succeed()
                        }
                    }
                }
                it("should return error") {
                    networkService.returnedError = MBError(description: "mock error",
                                                           type: MBErrorType.http(.locked(data: nil)))
                    
                    onboardGeofencingService.deleteOnboardFences(finOrVin: "WDD1770871Z000099", ids: ids) { (result) in
                        switch result {
                        case .failure(let error):
                            expect(error).to(matchError(OnboardGeofencingError.commandInProgress))
                        case .success:
                            fail()
                        }
                    }
                }
            }
        }
        
    }
}

extension CoordinateModel {
    static let sindelfingen = CoordinateModel(latitude: 48.7074558, longitude: 9.0044053)
}
