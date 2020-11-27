//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBRealmKit

/// Representation of the user management from the vehicle
public struct VehicleUserManagementModel {

	// MARK: Properties

	public let finOrVin: String
	public let metaData: UserManagementMetaDataModel
	public let owner: VehicleAssignedUserModel?
	public let users: [VehicleAssignedUserModel]?
	public let unassignedProfiles: [VehicleProfileModel]
}


extension VehicleUserManagementModel: Entity {
	
	public var id: String {
		return self.finOrVin
	}
}
