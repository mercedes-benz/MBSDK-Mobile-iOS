//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

extension NetworkModelMapper {

	static func map(apiVehicleUserManagement: APIVehicleUserManagementModel, finOrVin: String) -> VehicleUserManagementModel {

		let owner = self.map(apiVehicleAssignedUser: apiVehicleUserManagement.owner, status: .owner)

		var users: [VehicleAssignedUserModel] = []

		if let pending = apiVehicleUserManagement.users.pendingSubusers?.map({ self.map(apiVehicleAssignedUser: $0, status: .pending) }).compactMap({ $0 }) {
			users.append(contentsOf: pending)
		}
        
        if let temporary = apiVehicleUserManagement.users.temporarySubusers?.map({ self.map(apiVehicleAssignedUser: $0, status: .valid) }).compactMap({ $0 }) {
            users.append(contentsOf: temporary)
        }
        
		if let valid = apiVehicleUserManagement.users.validSubusers?.map({ self.map(apiVehicleAssignedUser: $0, status: .valid) }).compactMap({ $0 }) {
			users.append(contentsOf: valid)
		}

		return VehicleUserManagementModel(finOrVin: finOrVin,
										  metaData: self.map(apiMetaData: apiVehicleUserManagement.metaData),
										  owner: owner,
										  users: users,
										  unassignedProfiles: self.map(apiVehicleProfiles: apiVehicleUserManagement.unassignedProfiles))
	}

	private static func map(apiVehicleProfiles: [APIVehicleProfileModel]?) -> [VehicleProfileModel] {

		guard let profiles = apiVehicleProfiles else {
			return[]
		}

		return profiles.map({ VehicleProfileModel(id: $0.id, name: $0.profileName) })
	}

	private static func map(apiMetaData: APIUserManagementMetaDataModel) -> UserManagementMetaDataModel {
		return UserManagementMetaDataModel(maxProfileNumber: apiMetaData.maxNumberOfProfiles ?? 0,
										   occupiedProfilesNumber: apiMetaData.numberOfOccupiedProfiles ?? 0,
										   profileSyncStatus: VehicleProfileSyncStatus(rawValue: apiMetaData.profileSyncStatus ?? "") ?? .unknown)
	}

	private static func map(apiVehicleAssignedUser: APIVehicleAssignedUserModel, status: VehicleAssignedUserStatus = .pending) -> VehicleAssignedUserModel {
        return VehicleAssignedUserModel(authorizationId: apiVehicleAssignedUser.authorizationId ?? "",
										displayName: apiVehicleAssignedUser.displayName ?? "",
										email: apiVehicleAssignedUser.email,
										mobileNumber: apiVehicleAssignedUser.mobileNumber,
										status: status,
										userImageURL: apiVehicleAssignedUser.profilePictureLink,
                                        validUntil: DateFormattingHelper.date(apiVehicleAssignedUser.validUntil, format: DateFormat.iso8601) )
	}
}
