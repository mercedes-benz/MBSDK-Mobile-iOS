//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

@objcMembers class DBVehicleServicePrerequisiteModel: Object {
	
	// MARK: Properties
	dynamic var actions: String = ""
	dynamic var missingFields: String = ""
	dynamic var name: String = ""
	
	let service = LinkingObjects(fromType: DBVehicleServiceModel.self, property: "prerequisites")
}
