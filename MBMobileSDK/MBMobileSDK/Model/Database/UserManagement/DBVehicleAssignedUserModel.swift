//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

@objcMembers class DBVehicleAssignedUserModel: Object {

	// MARK: Properties
    
	dynamic var authorizationId: String = ""
	dynamic var displayName: String = ""
	dynamic var email: String?
	dynamic var mobileNumber: String?
	dynamic var status: String = VehicleAssignedUserStatus.pending.rawValue
	dynamic var userImageUrl: String?
    dynamic var validUntil: String?


	// MARK: - Realm
	
	public override func isEqual(_ object: Any?) -> Bool {

		guard let rhs = object as? DBVehicleAssignedUserModel else {
			return false
		}

		return self.authorizationId == rhs.authorizationId &&
			self.displayName == rhs.displayName &&
			self.email == rhs.email &&
			self.mobileNumber == rhs.mobileNumber &&
			self.status == rhs.status &&
			self.userImageUrl == rhs.userImageUrl &&
			self.validUntil == rhs.validUntil
	}
}
