//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

@objcMembers class DBVehicleCommandParameterModel: Object {
	
	// MARK: Properties
	dynamic var allowedBool: String = ""
	dynamic var allowedEnums: String = ""
    dynamic var maxValue: Double = 0.0
    dynamic var minValue: Double = 0.0
	dynamic var parameterName: String = ""
    dynamic var steps: Double = 0.0
}
