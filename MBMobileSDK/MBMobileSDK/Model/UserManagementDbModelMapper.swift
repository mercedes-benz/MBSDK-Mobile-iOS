//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift
import MBRealmKit

class UserManagementDbModelMapper: DbModelMapping {
	
	typealias BusinessModel = VehicleUserManagementModel
	typealias DbModel = DBVehicleUserManagementModel
	
	func map(_ dbModel: DBVehicleUserManagementModel) -> VehicleUserManagementModel {
		return VehicleUserManagementModel(finOrVin: dbModel.finOrVin,
										  metaData: self.map(dbModel.metaData),
										  owner: self.map(dbModel.owner),
										  users: self.map(dbModel.users),
										  unassignedProfiles: [])
	}
	
	func map(_ businessModel: VehicleUserManagementModel) -> DBVehicleUserManagementModel {
		
		let dbModel = DBVehicleUserManagementModel()
		dbModel.finOrVin = businessModel.finOrVin
		dbModel.metaData = self.map(businessModel.metaData)
		dbModel.owner = self.map(businessModel.owner)
		dbModel.users.append(objectsIn: businessModel.users?.compactMap { self.map($0) } ?? [])
		return dbModel
	}
	
	
	// MARK: - Helper
	
	private func map(_ dbMetaData: DBUserManagementMetaDataModel?) -> UserManagementMetaDataModel {
		return UserManagementMetaDataModel(maxProfileNumber: dbMetaData?.maxProfileNumber ?? 0,
										   occupiedProfilesNumber: dbMetaData?.occupiedProfilesNumber ?? 0,
										   profileSyncStatus: VehicleProfileSyncStatus(rawValue: dbMetaData?.profileSyncStatus ?? "") ?? .unsupported)
	}
	
	private func map(_ dbVehicleAssignedUserList: List<DBVehicleAssignedUserModel>?) -> [VehicleAssignedUserModel] {

		guard let users = dbVehicleAssignedUserList else {
			return []
		}

		return users.compactMap { (assignedUserItem) -> VehicleAssignedUserModel? in
			return self.map(assignedUserItem)
		}
	}
	
	private func map(_ dbVehicleAssignedUser: DBVehicleAssignedUserModel?) -> VehicleAssignedUserModel? {
		
		guard let dbVehicleAssignedUser = dbVehicleAssignedUser else {
			return nil
		}
		return VehicleAssignedUserModel(authorizationId: dbVehicleAssignedUser.authorizationId,
										displayName: dbVehicleAssignedUser.displayName,
										email: dbVehicleAssignedUser.email,
										mobileNumber: dbVehicleAssignedUser.mobileNumber,
										status: VehicleAssignedUserStatus(rawValue: dbVehicleAssignedUser.status) ?? .unknown,
										userImageURL: dbVehicleAssignedUser.userImageUrl,
										validUntil: DateFormattingHelper.date(dbVehicleAssignedUser.validUntil, format: DateFormat.iso8601))
	}
	
	func map(_ businessModel: UserManagementMetaDataModel) -> DBUserManagementMetaDataModel {

		let dbMetaData = DBUserManagementMetaDataModel()
		dbMetaData.maxProfileNumber = businessModel.maxProfileNumber
		dbMetaData.occupiedProfilesNumber = businessModel.occupiedProfilesNumber
		dbMetaData.profileSyncStatus = businessModel.profileSyncStatus.rawValue
		return dbMetaData
	}

	func map(_ businessModel: VehicleAssignedUserModel?) -> DBVehicleAssignedUserModel? {

		guard let businessModel = businessModel else {
			return nil
		}
		
		let user = DBVehicleAssignedUserModel()
		user.authorizationId = businessModel.authorizationId
		user.displayName = businessModel.displayName
		user.email = businessModel.email
		user.mobileNumber = businessModel.mobileNumber
		user.status = businessModel.status.rawValue
		user.userImageUrl = businessModel.userImageURL?.absoluteString
		user.validUntil = DateFormattingHelper.string(businessModel.validUntil, format: DateFormat.iso8601)
		return user
	}
}
