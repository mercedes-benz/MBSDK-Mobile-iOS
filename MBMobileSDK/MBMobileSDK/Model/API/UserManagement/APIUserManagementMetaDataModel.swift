//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIUserManagementMetaDataModel: Decodable {

	let maxNumberOfProfiles: Int?
	let numberOfOccupiedProfiles: Int?
	let profileSyncStatus: String?
}
