//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

@objcMembers class DBVehicleUserManagementModel: Object {

	// MARK: Properties

	dynamic var finOrVin: String = ""
	dynamic var metaData: DBUserManagementMetaDataModel?
	dynamic var owner: DBVehicleAssignedUserModel?
	
	let users = List<DBVehicleAssignedUserModel>()


	// MARK: - Realm

	override class func primaryKey() -> String? {
		return #keyPath(finOrVin)
	}
	
	public override func isEqual(_ object: Any?) -> Bool {

		guard let rhs = object as? DBVehicleUserManagementModel else {
			return false
		}

		return self.finOrVin == rhs.finOrVin &&
			self.owner == rhs.owner &&
			self.metaData == rhs.metaData
	}
}
