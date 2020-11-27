//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Nimble
import Quick

import MBCommonKit
import MBNetworkKit

@testable import MBMobileSDK

class VehicleServiceTests: QuickSpec {

	override func spec() {
		
		var networkService: MockNetworkService!
		var vehicleService: VehicleServiceRepresentable!
        var tokenProvider: MockTokenProvider!
		
		let finOrVin = "MOCKVIN871Z000099"
		
		beforeEach {
			
			networkService = MockNetworkService()
            tokenProvider = MockTokenProvider()
			vehicleService = VehicleService(networking: networkService,
											userManagementService: UserManagementService(networking: networkService,
																						 tokenProviding: tokenProvider,
																						 localeProvider: MockLocaleProviding()),
											tokenProviding: tokenProvider,
											localeProvider: MockLocaleProviding(),
											dbCommandCapabilitiesStore: CommandCapabilitiesDbStore(),
											dbUserManagementStore: UserManagementDbStore(config: MockRealmConfiguration()),
											dbVehicleSelectionStore: VehicleSelectionDbStore(config: MockRealmConfiguration()),
											dbVehicleStore: VehicleDbStore(config: MockRealmConfiguration()))
		}
		
		describe(".automaticValetParking") {
			beforeEach {
				networkService.reset()
			}
			
			let requestModel = AcceptAVPDriveModel(bookingId: "mock_booking_id", startDrive: true)

			it("should complete with error") {
			
				let returnedError = MBError(description: "mockError", type: .unknown)
				networkService.returnedError = returnedError
			
				vehicleService.automaticValetParking(finOrVin: finOrVin, requestModel: requestModel) { (result) in
			
					switch result {
					case .failure(let error):
						expect(error).to(matchError(returnedError))
			
					case .success:
						fail()
					}
				}
			}
			
			it("should complete with success") {
			
				vehicleService.automaticValetParking(finOrVin: finOrVin, requestModel: requestModel) { (result) in
			
					switch result {
					case .failure:
						fail()
			
					case .success:
						_ = succeed()
					}
				}
			}
		}
		
		describe(".avpReservationStatus") {
			beforeEach {
				networkService.reset()
			}
			
			let reservationIds = [
				"mock_id_1",
				"mock_id_2"
			]

			it("should complete with error") {
			
				let returnedError = MBError(description: "mockError", type: .unknown)
				networkService.returnedError = returnedError
			
				vehicleService.avpReservationStatus(finOrVin: finOrVin, reservationIds: reservationIds) { (result) in
			
					switch result {
					case .failure(let error):
						expect(error).to(matchError(returnedError))
			
					case .success:
						fail()
					}
				}
			}
			
			it("should complete with success") {
			
				networkService.returnedDecodable = [
					APIAVPReservationStatusModel(reservationId: "mock_reservation_id",
												 driveType: "mock_drive_type",
												 driveStatus: "mock_drive_status",
												 errorIds: nil,
												 estimatedTimeOfArrival: nil,
												 parkedLocation: nil)
				]
				
				vehicleService.avpReservationStatus(finOrVin: finOrVin, reservationIds: reservationIds) { (result) in
			
					switch result {
					case .failure:
						fail()
			
					case .success(let avpReservationStatusModels):
						expect(avpReservationStatusModels.count) == 1
						expect(avpReservationStatusModels.first?.reservationId) == "mock_reservation_id"
					}
				}
			}
		}
		
		describe(".fetchCommandCapabilities") {
			beforeEach {
				networkService.reset()
			}
			
			it("should complete with error") {
			
				let returnedError = MBError(description: "mockError", type: .unknown)
				networkService.returnedError = returnedError
			
				vehicleService.fetchCommandCapabilities(finOrVin: finOrVin) { (result) in
			
					switch result {
					case .failure(let error):
						expect(error).to(matchError(returnedError))
			
					case .success:
						fail()
					}
				}
			}
			
//			it("should complete with success") {
//				
//				networkService.returnedDecodable = [
//					APICommandCapabilityModel(additionalInformation: nil,
//											  commandName: nil,
//											  isAvailable: true,
//											  parameters: nil)
//				]
//				
//				vehicleService.fetchCommandCapabilities(finOrVin: finOrVin) { (result) in
//			
//					switch result {
//					case .failure:
//						fail()
//			
//					case .success(let commandCapabilities):
//						expect(commandCapabilities.capabilities.first?.additionalInformation.isEmpty) == true
//					}
//				}
//			}
		}
		
		describe(".fetchConsumption") {
			beforeEach {
				networkService.reset()
			}

			it("should complete with error") {

				let returnedError = MBError(description: "mockError", type: .unknown)
				networkService.returnedError = returnedError

				vehicleService.fetchConsumption(finOrVin: finOrVin) { (result) in

					switch result {
					case .failure(let error):
						expect(error).to(matchError(returnedError))

					case .success:
						fail()
					}
				}
			}

			it("should complete with success") {

				let entryModel = APIVehicleConsumptionEntryModel(changed: true,
																 unit: .kilometersPerLiter,
																 value: 0.5)
				networkService.returnedDecodable = APIVehicleConsumptionModel(averageConsumption: entryModel,
																			  consumptionData: APIVehicleConsumptionDataModel(changed: true,
																															  value: []),
																			  individual30DaysConsumption: APIVehicleConsumptionIndividual30DaysModel(lastUpdated: nil,
																																					  unit: .kilometersPerLiter,
																																					  value: 0.5),
																			  individualLifetimeConsumption: entryModel,
																			  individualResetConsumption: entryModel,
																			  individualStartConsumption: entryModel,
																			  wltpCombined: entryModel)
				vehicleService.fetchConsumption(finOrVin: finOrVin) { (result) in

					switch result {
					case .failure:
						fail()

					case .success(let vehicleConsumption):
						expect(vehicleConsumption.averageConsumption?.changed) == entryModel.changed
						expect(vehicleConsumption.averageConsumption?.unit) == entryModel.unit
						expect(vehicleConsumption.averageConsumption?.value) == entryModel.value
					}
				}
			}
		}

//		describe(".fetchVehicles") {
//			beforeEach {
//				networkService.reset()
//			}
//
//			it("should complete with error") {
//
//				let returnedError = MBError(description: "mockError", type: .unknown)
//				networkService.returnedError = returnedError
//
//				vehicleService.fetchVehicles { (result) in
//
//					switch result {
//					case .failure(let error):
//						let mockError = errorHandler.handle(error: returnedError)
//						expect(error).to(matchError(mockError))
//
//					case .success:
//						fail()
//					}
//				}
//			}
//
//			it("should complete with success") {
//
//				vehicleService.fetchVehicles { (result) in
//
//					switch result {
//					case .failure:
//						fail()
//
//					case .success:
//						_ = succeed()
//					}
//				}
//			}
//		}

//		describe(".instantSelectVehicle") {
//			beforeEach {
//				networkService.reset()
//			}
//
//			it("should complete with error") {
//
//				let returnedError = MBError(description: "mockError", type: .unknown)
//				networkService.returnedError = returnedError
//
//				vehicleService.instantSelectVehicle { (finOrVin) in
//					expect(finOrVin).to(beNil())
//				}
//			}
//
//			it("should complete with success") {
//
//				vehicleService.instantSelectVehicle { (finOrVin) in
//					expect(finOrVin) == ""
//				}
//			}
//		}

		describe(".getPinSyncState") {
			beforeEach {
				networkService.reset()
			}

			it("should complete with error") {

				let returnedError = MBError(description: "mockError", type: .unknown)
				networkService.returnedError = returnedError

				vehicleService.getPinSyncState(finOrVin: finOrVin) { (result) in

					switch result {
					case .failure(let error):
						expect(error).to(matchError(returnedError))

					case .success:
						fail()
					}
				}
			}

			it("should complete with success") {

				networkService.returnedDecodable = APIPinSyncState(status: .set)

				vehicleService.getPinSyncState(finOrVin: finOrVin) { (result) in

					switch result {
					case .failure:
						fail()

					case .success(let state):
						expect(state) == .set
					}
				}
			}
		}
        
        describe(".getProfileSyncState") {
            beforeEach {
                networkService.reset()
            }
            
            it("sould be complete with error") {
                
                let returnedError = MBError(description: "mockError", type: .unknown)
                networkService.returnedError = returnedError
                
                vehicleService.getProfileSyncState(finOrVin: finOrVin) { (result) in
                    
                    switch result {
                    case .failure(let error):
                        expect(error).to(matchError(returnedError))
                        
                    case .success:
                        fail()
                    }
                }
            }
            
            it("should be complete with success") {
                
                networkService.returnedDecodable = APIProfileSyncState(profileSyncStatus: .on)
                
                vehicleService.getProfileSyncState(finOrVin: finOrVin) { (result) in
                    
                    switch result {
                    case .failure:
                        fail()
                        
                    case .success(let state):
                        expect(state) == .on
                    }
                }
            }
            
        }

		describe(".updateLicense") {
			beforeEach {
				networkService.reset()
			}

			let licensePlate = "mock_license_plate"

			it("should complete with error") {

				let returnedError = MBError(description: "mockError", type: .unknown)
				networkService.returnedError = returnedError

				vehicleService.updateLicense(finOrVin: finOrVin, licensePlate: licensePlate) { (result) in

					switch result {
					case .failure(let error):
						expect(error).to(matchError(returnedError))

					case .success:
						fail()
					}
				}
			}

//			it("should complete with success") {
//
//				vehicleService.updateLicense(finOrVin: finOrVin, licensePlate: licensePlate) { (result) in
//
//					switch result {
//					case .failure:
//						fail()
//
//					case .success:
//						_ = succeed()
//					}
//				}
//			}
		}
		
		describe(".updatePreferredDealer") {
			beforeEach {
				networkService.reset()
			}

			let preferredDealers = [
				VehicleDealerUpdateModel(dealerId: "mock_dealer_id",
										 role: .sales)
			]
			
			it("should complete with error") {

				let returnedError = MBError(description: "mockError", type: .unknown)
				networkService.returnedError = returnedError

				vehicleService.updatePreferredDealer(finOrVin: finOrVin, preferredDealers: preferredDealers) { (result) in

					switch result {
					case .failure(let error):
						expect(error).to(matchError(returnedError))

					case .success:
						fail()
					}
				}
			}

			it("should complete with success") {

				networkService.returnedDecodable = APIPinSyncState(status: .set)
				
				vehicleService.updatePreferredDealer(finOrVin: finOrVin, preferredDealers: preferredDealers) { (result) in

					switch result {
					case .failure:
						fail()

					case .success:
						_ = succeed()
					}
				}
			}
		}
        
        describe(".getSoftwareUpdate") {
            beforeEach {
                networkService.reset()
            }
            
            it("should complete with token error") {
                tokenProvider.token = nil
                
                vehicleService.getSoftwareUpdate(finOrVin: finOrVin, locale: "en-GB") { (result) in
                    switch result {
                    case .failure(let error):
                    expect(error).to(matchError(VehicleServiceError.tokenRefreshError))
                    case .success:
                        fail()
                    }
                }
            }
            
            it("should complete with network error") {
                let returnedError = MBError(description: "mockError", type: .unknown)
                networkService.returnedError = returnedError
                
                vehicleService.getSoftwareUpdate(finOrVin: finOrVin, locale: "en-GB") { (result) in
                    switch result {
                    case .failure(let error):
                        expect(error).to(matchError(VehicleServiceError.network(returnedError)))

                    case .success:
                        fail()
                    }
                }
            }
            
            it("should complete with success") {
                
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                let lastSynchronization = formatter.date(from: "2020-11-19T08:00:00.000Z")
                let timestamp = formatter.date(from: "2020-11-18T10:00:00.000Z")

                networkService.returnedDecodable = APISoftwareUpdateModel.example
                
                vehicleService.getSoftwareUpdate(finOrVin: finOrVin, locale: "en-GB") { (result) in
                    switch result {
                    case .failure:
                        fail()
                    case .success(let model):
                        guard let firstUpdateItem = model.updates.first else {
                            fail()
                            return
                        }
                        
                        expect(model.totalUpdates)          == 1
                        expect(model.availableUpdates)      == 1
                        expect(model.lastSynchronization)   == lastSynchronization
                        expect(model.updates.count)         == 1
                        
                        expect(firstUpdateItem.title)        == "My campain"
                        expect(firstUpdateItem.description)  == "This is a campain"
                        expect(firstUpdateItem.timestamp)    == timestamp
                        expect(firstUpdateItem.status)       == .pending
                    }
                }
            }
        }
	}
}

fileprivate extension APISoftwareUpdateModel {
    static let example: APISoftwareUpdateModel = {
        return APISoftwareUpdateModel(totalUpdates: 1,
                                      availableUpdates: 1,
                                      lastSynchronization: "2020-11-19T08:00:00.000Z",
                                      updates: [APISoftwareUpdateItemModel.example])
    }()
}

fileprivate extension APISoftwareUpdateItemModel {
    static let example: APISoftwareUpdateItemModel = {
        return APISoftwareUpdateItemModel(title: "My campain",
                                          description: "This is a campain",
                                          timestamp: "2020-11-18T10:00:00.000Z",
                                          status: .pending)
    }()
}
