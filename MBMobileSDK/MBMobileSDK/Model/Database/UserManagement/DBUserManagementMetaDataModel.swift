//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

@objcMembers class DBUserManagementMetaDataModel: Object {

	// MARK: Properties

	dynamic var maxProfileNumber: Int = 0
	dynamic var occupiedProfilesNumber: Int = 0
	dynamic var profileSyncStatus: String = ""


	// MARK: - Realm

	public override func isEqual(_ object: Any?) -> Bool {

		guard let rhs = object as? DBUserManagementMetaDataModel else {
			return false
		}

		return self.maxProfileNumber == rhs.maxProfileNumber &&
			self.occupiedProfilesNumber == rhs.occupiedProfilesNumber &&
			self.profileSyncStatus == rhs.profileSyncStatus
	}
}
