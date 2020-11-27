//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIVehicleUserManagementModel: Decodable {

	let metaData: APIUserManagementMetaDataModel
	let owner: APIVehicleAssignedUserModel
	let users: APIVehicleAssignedSubuserModel
	let unassignedProfiles: [APIVehicleProfileModel]?

	enum CodingKeys: String, CodingKey {
		case owner
		case metaData = "generalData"
		case users = "subUsers"
		case unassignedProfiles = "localProfiles"
	}
}
