//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import RealmSwift

@objcMembers public class DBVehicleServiceMissingDataModel: Object {
	
	// MARK: Properties
	dynamic var accountLinkageMandatory: Bool = false
	dynamic var accountLinkageType: String = ""
}
