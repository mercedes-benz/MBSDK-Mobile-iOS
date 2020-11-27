//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

@objcMembers public class DBVehicleServiceModel: Object {
	
	// MARK: Properties
	dynamic var activationStatus: String = ""
	dynamic var allowedActions: String = ""
	dynamic var categoryName: String = ""
	dynamic var categorySortIndex: Int = 0
	dynamic var finOrVin: String = ""
	dynamic var id: Int = 0
	dynamic var missingData: DBVehicleServiceMissingDataModel?
	dynamic var name: String = ""
	dynamic var pending: String = ""
	dynamic var primaryKey: String = ""
	dynamic var rights: String = ""
	dynamic var serviceDescription: String?
	dynamic var sortIndex: Int = 0
	dynamic var shortName: String?
	
	let prerequisites = List<DBVehicleServicePrerequisiteModel>()
	
	
	// MARK: - Realm
	
	override public static func primaryKey() -> String? {
		return "primaryKey"
	}
	
	
	// MARK: - Helper
	
	func setPrimaryKey() {
		self.primaryKey = self.finOrVin + "_" + "\(self.id)"
	}
}
