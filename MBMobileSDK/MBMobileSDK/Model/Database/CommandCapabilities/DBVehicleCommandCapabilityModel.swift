//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

@objcMembers class DBVehicleCommandCapabilityModel: Object {
	
	// MARK: Properties
	dynamic var additionalInformation: String = ""
	dynamic var commandName: String = ""
	dynamic var isAvailable: Bool = false

	let parameters = List<DBVehicleCommandParameterModel>()
}
