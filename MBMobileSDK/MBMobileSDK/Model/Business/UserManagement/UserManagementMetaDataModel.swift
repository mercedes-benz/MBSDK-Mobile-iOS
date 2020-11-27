//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of the meta data from the user management
public struct UserManagementMetaDataModel {

	// MARK: Properties

	public let maxProfileNumber: Int
	public let occupiedProfilesNumber: Int
	public let profileSyncStatus: VehicleProfileSyncStatus
}
