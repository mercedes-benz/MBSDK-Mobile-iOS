//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Nimble
import Quick

import MBCommonKit
import MBNetworkKit

@testable import MBMobileSDK

class SpeedFenceServiceTests: QuickSpec {
    
    override func spec() {
        var networkService: MockNetworkService!
        var tokenProvider: MockTokenProviding!
        var speedFenceService: SpeedFenceServiceRepresentable!
        
        beforeEach {
            networkService = MockNetworkService()
            tokenProvider = MockTokenProviding()
            speedFenceService = SpeedFenceService(networking: networkService, tokenProvider: tokenProvider)
        }
        
        context("SpeedFences") {
            describe("fetch SpeedFences") {
                it("should return token error") {
                    tokenProvider.token = nil
                    
                    speedFenceService.fetchSpeedfences(finOrVin: "WDD1770871Z000099", unit: .kmPerHour) { (result) in
                        switch result {
                        case .failure(let error):
                            expect(error).to(matchError(SpeedFenceServiceError.token))
                        case .success:
                            fail()
                        }
                    }
                }
                
                it("should return network error") {
                    let mbError = MBError(description: "", type: .http(.badRequest(data: nil)))
                    networkService.returnedError = mbError
                    
                    speedFenceService.fetchSpeedfences(finOrVin: "WDD1770871Z000099", unit: .kmPerHour) { (result) in
                        switch result {
                        case .failure(let error):
                            expect(error).to(matchError(SpeedFenceServiceError.network(mbError)))
                        case .success:
                            fail()
                        }
                    }
                }
                
                it("should return success") {
                    
                    let apiModel = APISpeedFenceModel(geofenceid: 1,
                                                      name: "Speedfence",
                                                      isActive: true,
                                                      endtime: 4,
                                                      threshold: 6,
                                                      violationdelay: 3,
                                                      violationtype: .leaveAndEnter,
                                                      ts: 4,
                                                      speedfenceid: 8,
                                                      syncstatus: .finished)
                    networkService.returnedDecodable = [apiModel]
                    
                    speedFenceService.fetchSpeedfences(finOrVin: "WDD1770871Z000099", unit: .kmPerHour) { (result) in
                        switch result {
                        case .failure:
                            fail()
                        case .success(let models):
                            
                            guard let model = models.first else {
                                fail()
                                return
                            }
                            
                            expect(model.geofenceId)     == 1
                            expect(model.name)           == "Speedfence"
                            expect(model.isActive)       == true
                            expect(model.endTime)        == 4
                            expect(model.threshold)      == 6
                            expect(model.violationDelay) == 3
                            expect(model.violationTypes) == .leaveAndEnter
                            expect(model.timestamp)      == 4
                            expect(model.speedfenceId)   == 8
                            expect(model.syncStatus)     == .finished
                        }
                    }
                }
            }
            
            describe("create SpeedFences") {
                let model = SpeedFenceRequestModel.create(geofenceId: 2,
                                                          name: "Speedfence",
                                                          isActive: true,
                                                          endTime: 3,
                                                          threshold: 9,
                                                          unit: .kmPerHour,
                                                          violationDelay: 3,
                                                          violationType: .leave)
                
                it("should return token error") {
                    tokenProvider.token = nil
                    speedFenceService.create(finOrVin: "WDD1770871Z000099", speedfences: [model]) { (result) in
                        switch result {
                        case .failure(let error):
                            expect(error).to(matchError(SpeedFenceServiceError.token))
                        case .success:
                            fail()
                        }
                    }
                }
                
                it("should return network error") {
                    let mbError = MBError(description: "", type: .http(.badRequest(data: nil)))
                    networkService.returnedError = mbError
                    
                    speedFenceService.create(finOrVin: "WDD1770871Z000099", speedfences: [model]) { (result) in
                        switch result {
                        case .failure(let error):
                            expect(error).to(matchError(SpeedFenceServiceError.network(mbError)))
                        case .success:
                            fail()
                        }
                    }
                }
                
                it("should return success") {
                    
                    speedFenceService.create(finOrVin: "WDD1770871Z000099", speedfences: [model]) { (result) in
                        switch result {
                        case .failure:
                            fail()
                        case .success:
                            success()
                        }
                    }
                    
                }
            }
            
            describe("update SpeedFences") {
                let model = SpeedFenceRequestModel.update(speedfenceId: 3,
                                                          geofenceId: 2,
                                                          name: "Speedfence",
                                                          isActive: true,
                                                          endTime: 3,
                                                          threshold: 9,
                                                          unit: .kmPerHour,
                                                          violationDelay: 3,
                                                          violationType: .leave)
                
                it("should return token error") {
                    tokenProvider.token = nil
                    speedFenceService.update(finOrVin: "WDD1770871Z000099", speedfences: [model]) { (result) in
                        switch result {
                        case .failure(let error):
                            expect(error).to(matchError(SpeedFenceServiceError.token))
                        case .success:
                            fail()
                        }
                    }
                }
                
                it("should return network error") {
                    let mbError = MBError(description: "", type: .http(.badRequest(data: nil)))
                    networkService.returnedError = mbError
                    
                    speedFenceService.update(finOrVin: "WDD1770871Z000099", speedfences: [model]) { (result) in
                        switch result {
                        case .failure(let error):
                            expect(error).to(matchError(SpeedFenceServiceError.network(mbError)))
                        case .success:
                            fail()
                        }
                    }
                }
                
                it("should return success") {
                    
                    speedFenceService.update(finOrVin: "WDD1770871Z000099", speedfences: [model]) { (result) in
                        switch result {
                        case .failure:
                            fail()
                        case .success:
                            success()
                        }
                    }
                    
                }
            }
            
            describe("delete SpeedFences") {
                let model = [1, 2, 6]
                
                it("should return token error") {
                    tokenProvider.token = nil
                    speedFenceService.deleteSpeedfences(finOrVin: "WDD1770871Z000099", speedfences: model) { (result) in
                        switch result {
                        case .failure(let error):
                            expect(error).to(matchError(SpeedFenceServiceError.token))
                        case .success:
                            fail()
                        }
                    }
                }
                
                it("should return network error") {
                    let mbError = MBError(description: "", type: .http(.badRequest(data: nil)))
                    networkService.returnedError = mbError
                    
                    speedFenceService.deleteSpeedfences(finOrVin: "WDD1770871Z000099", speedfences: model) { (result) in
                        switch result {
                        case .failure(let error):
                            expect(error).to(matchError(SpeedFenceServiceError.network(mbError)))
                        case .success:
                            fail()
                        }
                    }
                }
                
                it("should return success") {
                    
                    speedFenceService.deleteSpeedfences(finOrVin: "WDD1770871Z000099", speedfences: model) { (result) in
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
        
        context("SpeedFences Violations") {
            describe("fetch Violations") {
                it("should return token error") {
                    tokenProvider.token = nil
                    
                    speedFenceService.fetchViolations(finOrVin: "WDD1770871Z000099", unit: .kmPerHour) { (result) in
                        switch result {
                        case .failure(let error):
                            expect(error).to(matchError(SpeedFenceServiceError.token))
                        case .success:
                            fail()
                        }
                    }
                }
                
                it("should return network error") {
                    let mbError = MBError(description: "", type: .http(.badRequest(data: nil)))
                    networkService.returnedError = mbError
                    
                    speedFenceService.fetchViolations(finOrVin: "WDD1770871Z000099", unit: .kmPerHour) { (result) in
                        switch result {
                        case .failure(let error):
                            expect(error).to(matchError(SpeedFenceServiceError.network(mbError)))
                        case .success:
                            fail()
                        }
                    }
                }
                
                it("should return success") {
                    
                    let apiModel = APISpeedFenceViolationModel(coordinates: APICoordinateModel(latitude: 48.7074558,
                                                                                               longitude: 9.0044053),
                                                               speedfence: nil,
                                                               onboardfence: nil,
                                                               time: 3,
                                                               violationid: 5)
                    networkService.returnedDecodable = [apiModel]
                    
                    speedFenceService.fetchViolations(finOrVin: "WDD1770871Z000099", unit: .kmPerHour) { (result) in
                        switch result {
                        case .failure:
                            fail()
                        case .success(let models):
                            
                            guard let model = models.first else {
                                fail()
                                return
                            }
                            
                            expect(model.coordinate?.latitude)     == 48.7074558
                            expect(model.coordinate?.longitude)    == 9.0044053
                            expect(model.time)           == 3
                            expect(model.violationId)    == 5
                        }
                    }
                }
            }
            
            describe("delete Violations") {
                let model = [1, 2, 6]
                
                it("should return token error") {
                    tokenProvider.token = nil
                    speedFenceService.deleteViolations(finOrVin: "WDD1770871Z000099", speedfences: model) { (result) in
                        switch result {
                        case .failure(let error):
                            expect(error).to(matchError(SpeedFenceServiceError.token))
                        case .success:
                            fail()
                        }
                    }
                }
                
                it("should return network error") {
                    let mbError = MBError(description: "", type: .http(.badRequest(data: nil)))
                    networkService.returnedError = mbError
                    
                    speedFenceService.deleteViolations(finOrVin: "WDD1770871Z000099", speedfences: model) { (result) in
                        switch result {
                        case .failure(let error):
                            expect(error).to(matchError(SpeedFenceServiceError.network(mbError)))
                        case .success:
                            fail()
                        }
                    }
                }
                
                it("should return success") {
                    
                    speedFenceService.deleteViolations(finOrVin: "WDD1770871Z000099", speedfences: model) { (result) in
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
