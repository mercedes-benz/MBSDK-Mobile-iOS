//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

@objcMembers class DBVehicleStatusTariffModel: Object {
	
	dynamic var displayValue: String = ""
	dynamic var status: Int32 = 0
	dynamic var timestamp: Int64 = 0
	
	let rates = List<Int32>()
	let times = List<Int32>()
}
