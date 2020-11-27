//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

/// Database class of vehicle supportable data object
@objcMembers public class DBVehicleSupportableModel: Object {
	
	// MARK: Properties
	dynamic var canReceiveVACs: Bool = false
	dynamic var finOrVin: String = ""
    dynamic var vehicleConnectivity: String = ""
	
	
	// MARK: - Realm
	
	override public static func primaryKey() -> String? {
		return "finOrVin"
	}
}
