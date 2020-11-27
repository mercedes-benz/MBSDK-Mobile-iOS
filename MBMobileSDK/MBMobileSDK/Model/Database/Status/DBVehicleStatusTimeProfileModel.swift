//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class DBVehicleStatusTimeProfileModel: Object {
	
	dynamic var active: Bool = false
	dynamic var applicationIdentifier: Int = 0
	dynamic var identifier: Int = 0
	dynamic var hour: Int = 0
	dynamic var minute: Int = 0
	
	let days = List<Int>()
}
