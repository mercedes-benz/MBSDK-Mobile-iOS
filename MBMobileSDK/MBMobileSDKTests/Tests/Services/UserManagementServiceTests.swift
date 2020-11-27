//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Nimble
import Quick

import MBCommonKit
import MBNetworkKit

@testable import MBMobileSDK

class UserManagementServiceTests: QuickSpec {

	override func spec() {
		
		var networkService: MockNetworkService!
		var userManagementService: UserManagementServiceRepresentable!
		
		let finOrVin = "MOCKVIN871Z000099"
		
		beforeEach {
			
			networkService = MockNetworkService()
			userManagementService = UserManagementService(networking: networkService,
														  tokenProviding: MockTokenProvider(),
                                                          localeProvider: MockLocaleProviding())
		}
		
		describe(".fetchVehicleAssignedUsers") {
			beforeEach {
				networkService.reset()
			}

			it("should complete with error") {

				let returnedError = MBError(description: "mockError", type: .unknown)
				networkService.returnedError = returnedError
				
				userManagementService.fetchVehicleAssignedUsers(finOrVin: finOrVin) { (result) in
					
					switch result {
					case .failure(let error):
						expect(error).to(matchError(returnedError))
					
					case .success:
						fail()
					}
				}
			}

			it("should complete with success") {
				
				networkService.returnedDecodable = APIVehicleUserManagementModel(metaData: APIUserManagementMetaDataModel(maxNumberOfProfiles: nil,
																														  numberOfOccupiedProfiles: nil,
																														  profileSyncStatus: nil),
																				 owner: APIVehicleAssignedUserModel(authorizationId: nil,
																													displayName: nil,
																													email: nil,
																													mobileNumber: nil,
																													profilePictureLink: nil,
																													validUntil: nil),
																				 users: APIVehicleAssignedSubuserModel(pendingSubusers: nil,
																													   temporarySubusers: nil,
																													   validSubusers: nil),
																				 unassignedProfiles: nil)

				userManagementService.fetchVehicleAssignedUsers(finOrVin: finOrVin) { (result) in
					
					switch result {
					case .failure:
						fail()
					
					case .success(let vehicleUserManagementModel):
						expect(vehicleUserManagementModel.unassignedProfiles).to(beNil())
					}
				}
			}
		}
		
		describe(".fetchInvitationQrCode") {
			beforeEach {
				networkService.reset()
			}

			let profileId = "mock_profile_id"
			
			it("should complete with error") {

				let returnedError = MBError(description: "mockError", type: .unknown)
				networkService.returnedError = returnedError
				
				userManagementService.fetchInvitationQrCode(finOrVin: finOrVin, profileId: profileId) { (result) in
					
					switch result {
					case .failure(let error):
						expect(error).to(matchError(returnedError))
					
					case .success:
						fail()
					}
				}
			}

			it("should complete with success") {
				
				networkService.returnedData = Data(base64Encoded: "mock_test_data_string")

				userManagementService.fetchInvitationQrCode(finOrVin: finOrVin, profileId: profileId) { (result) in
					
					switch result {
					case .failure:
						fail()
					
					case .success(let data):
						expect(data) == networkService.returnedData
					}
				}
			}
		}
		
		describe(".removeUserAuthorization") {
			beforeEach {
				networkService.reset()
			}

			let authorizationId = "mock_authorization_id"
			
			it("should complete with error") {

				let returnedError = MBError(description: "mockError", type: .unknown)
				networkService.returnedError = returnedError
				
				userManagementService.removeUserAuthorization(finOrVin: finOrVin, authorizationID: authorizationId) { (result) in
					
					switch result {
					case .failure(let error):
						expect(error).to(matchError(returnedError))
					
					case .success:
						fail()
					}
				}
			}

			it("should complete with success") {

				userManagementService.removeUserAuthorization(finOrVin: finOrVin, authorizationID: authorizationId) { (result) in
					
					switch result {
					case .failure:
						fail()
					
					case .success:
						_ = succeed()
					}
				}
			}
		}
		
		describe(".setProfileSync") {
			beforeEach {
				networkService.reset()
			}

			let enabled = true
			
			it("should complete with error") {

				let returnedError = MBError(description: "mockError", type: .unknown)
				networkService.returnedError = returnedError
				
				userManagementService.setProfileSync(enabled: enabled, finOrVin: finOrVin) { (result) in
					
					switch result {
					case .failure(let error):
						expect(error).to(matchError(returnedError))
					
					case .success:
						fail()
					}
				}
			}

			it("should complete with success") {

				userManagementService.setProfileSync(enabled: enabled, finOrVin: finOrVin) { (result) in
					
					switch result {
					case .failure:
						fail()
					
					case .success:
						_ = succeed()
					}
				}
			}
		}
		
		describe(".upgradeTemporaryUser") {
			beforeEach {
				networkService.reset()
			}

			let authorizationId = "mock_authorization_id"
			
			it("should complete with error") {

				let returnedError = MBError(description: "mockError", type: .unknown)
				networkService.returnedError = returnedError
				
				userManagementService.upgradeTemporaryUser(authorizationID: authorizationId, finOrVin: finOrVin) { (result) in
					
					switch result {
					case .failure(let error):
						expect(error).to(matchError(returnedError))
					
					case .success:
						fail()
					}
				}
			}

			it("should complete with success") {
				

				userManagementService.upgradeTemporaryUser(authorizationID: authorizationId, finOrVin: finOrVin) { (result) in
					
					switch result {
					case .failure:
						fail()
					
					case .success:
						_ = succeed()
					}
				}
			}
		}
		
		// fetch the status for normalized profile control
		describe(".fetchNormalizedProfileControl") {
			 beforeEach {
				 networkService.reset()
			 }
			 
			 it("sould be complete with error") {
				 
				let returnedError = MBError(description: "mockError", type: .unknown)
				networkService.returnedError = returnedError
				 
				userManagementService.fetchNormalizedProfileControl { (result) in
					 
					 switch result {
					 case .failure(let error):
						 expect(error).to(matchError(returnedError))
						 
					 case .success:
						 fail()
					 }
				 }
			 }
			 
			 it("should be complete with success") {

				 networkService.returnedDecodable = NormalizedProfileControlModel(enabled: true)

				 userManagementService.fetchNormalizedProfileControl { (result) in

					 switch result {
					 case .failure:
						 fail()

					 case .success(let status):
						expect(status.enabled) == true
					 }
				 }
			 }
			 
		 }
		
		// set normalized profile control
		describe(".setNormalizedProfileControl") {
			beforeEach {
				networkService.reset()
			}

			let enabled = true
			
			it("should complete with error") {

				let returnedError = MBError(description: "mockError", type: .unknown)
				networkService.returnedError = returnedError
				
				userManagementService.setNormalizedProfileControl(enabled: enabled) { (result) in
					
					switch result {
					case .failure(let error):
						expect(error).to(matchError(returnedError))
					
					case .success:
						fail()
					}
				}
			}

			it("should complete with success") {

				userManagementService.setNormalizedProfileControl(enabled: enabled) { (result) in
					
					switch result {
					case .failure:
						fail()
					
					case .success:
						_ = succeed()
					}
				}
			}
		}
		
	}
	
	func setDecodable<T: Decodable>(resource: String) -> T? {
		
		let bundle = Bundle(for: type(of: self))
		
		guard let url = bundle.url(forResource: resource, withExtension: "json"),
			let data = try? Data(contentsOf: url),
			let decodable = try? JSONDecoder().decode(T.self, from: data) else {
				return nil
		}
		return decodable
	}
}
