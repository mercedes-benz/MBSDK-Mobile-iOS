//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

@objcMembers class DBVehicleSelectionModel: Object {
	
	// MARK: Properties
	dynamic var finOrVin: String = ""
	dynamic var id: String = "1"
	
	
	// MARK: - Realm
	
	override class func primaryKey() -> String? {
		return "id"
	}
}
