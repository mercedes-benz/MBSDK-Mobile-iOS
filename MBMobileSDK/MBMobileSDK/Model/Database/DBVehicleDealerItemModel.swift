//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

@objcMembers class DBVehicleDealerItemModel: Object {
	
	// MARK: Properties
	dynamic var dealerId: String = ""
	dynamic var role: String = ""
	dynamic var merchant: DBDealerMerchantModel?

	let vehicle = LinkingObjects(fromType: DBVehicleModel.self, property: "dealers")
	
	
	// MARK: - Realm
	
	public override func isEqual(_ object: Any?) -> Bool {
		
		guard let rhs = object as? DBVehicleDealerItemModel else {
			return false
		}
		
		return self.dealerId == rhs.dealerId &&
			self.role == rhs.role
	}
}
