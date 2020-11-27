//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import MBNetworkKit

@testable import MBMobileSDK

class MockUserManagementService: UserManagementServiceRepresentable {
	
	func fetchVehicleAssignedUsers(finOrVin: String, completion: @escaping UserManagementService.VehicleAssignedUserSucceeded) {
		
	}
	
	func fetchInvitationQrCode(finOrVin: String, profileId: VehicleProfileID, completion: @escaping UserManagementService.VehicleQrCodeInvitationCompletion) {
		
	}
	
	func removeUserAuthorization(finOrVin: String, authorizationID: String, completion: @escaping UserManagementService.RemoveUserAuthorizationCompletion) {
		
	}
	
	func setProfileSync(enabled: Bool, finOrVin: String, completion: @escaping UserManagementService.SetProfileSyncCompletion) {
		
	}
	
	func upgradeTemporaryUser(authorizationID: String, finOrVin: String, completion: @escaping UserManagementService.UpgradeTemporaryUserCompletion) {
		
	}
	
	func fetchNormalizedProfileControl(completion: @escaping UserManagementService.NormalizedProfileControlCompletion) {
		
	}
	
	func setNormalizedProfileControl(enabled: Bool, completion: @escaping UserManagementService.SetNormalizedProfileControlCompletion) {
		
	}
	
}
