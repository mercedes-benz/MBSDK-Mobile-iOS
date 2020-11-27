//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

@objcMembers class DBVehicleStatusWeeklyProfileModel: Object {
	
	dynamic var displayValue: String = ""
	dynamic var status: Int32 = 0
	dynamic var timestamp: Int64 = 0
	
	dynamic var singleTimeProfileEntriesActivatable: Bool = false
	dynamic var maxNumberOfWeeklyTimeProfileSlots: Int32 = 0
	dynamic var maxNumberOfTimeProfiles: Int32 = 0
	dynamic var currentNumberOfTimeProfileSlots: Int32 = 0
	dynamic var currentNumberOfTimeProfiles: Int32 = 0

	let timeProfiles = List<DBVehicleStatusTimeProfileModel>()
}
