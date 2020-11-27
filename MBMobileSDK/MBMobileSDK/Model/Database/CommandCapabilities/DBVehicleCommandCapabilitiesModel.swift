//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

@objcMembers class DBVehicleCommandCapabilitiesModel: Object {
	
	// MARK: Properties
	dynamic var finOrVin: String = ""

	let capabilities = List<DBVehicleCommandCapabilityModel>()
	
	
	// MARK: - Realm
	
	override public static func primaryKey() -> String? {
		return "finOrVin"
	}
}
