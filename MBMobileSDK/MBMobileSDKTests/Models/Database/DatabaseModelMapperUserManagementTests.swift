//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import XCTest

@testable import MBMobileSDK

class DatabaseModelMapperUserManagementTests: XCTestCase {

    private struct Constants {
        static let finOrVin: String = "fin_or_vin"
        static let occupiedProfilesNumber: Int = 7
        static let maxProfileNumber: Int = 13
        static let profileSyncStatus: VehicleProfileSyncStatus = .serviceNotActive
        static let assignedUserAuthorizationId: String = "authorization_id"
        static let assignedUserDisplayName: String = "display_name"
        static let assignedUserEmail: String = "email"
        static let assignedUserMobileNumber: String = "mobile_number"
        static let assignedUserImageUrl: String = "image_url"
        static let assignedUserValidUntil: String = "2020-07-07T23:59:59.000Z"
        static let assignedUserValidUntilDescriptionCheck: String = "2020-07-07 23:59:59 +0000"
        static let assignedUserStatus: VehicleAssignedUserStatus = .owner
    }

	private let mapper = UserManagementDbModelMapper()
	
	
    // MARK: - Tests

    func testMapDBUserManagement() {
		
        let userManagementModel = DBVehicleUserManagementModel()
        userManagementModel.finOrVin = Constants.finOrVin
        userManagementModel.metaData = createDBMetaDataModel()
        let assignedUserModel = createDBAssignedUserModel()
        userManagementModel.owner = assignedUserModel
        userManagementModel.users.append(assignedUserModel)

		let mappedUserManagementModel = self.mapper.map(userManagementModel)
        XCTAssertNotNil(mappedUserManagementModel)
        XCTAssertEqual(mappedUserManagementModel.finOrVin, Constants.finOrVin)

        let mappedMetaDataModel = mappedUserManagementModel.metaData
        XCTAssertEqual(mappedMetaDataModel.occupiedProfilesNumber, Constants.occupiedProfilesNumber)
        XCTAssertEqual(mappedMetaDataModel.maxProfileNumber, Constants.maxProfileNumber)
        XCTAssertEqual(mappedMetaDataModel.profileSyncStatus, Constants.profileSyncStatus)

        let mappedOwner = mappedUserManagementModel.owner
        XCTAssertEqual(mappedOwner?.validUntil?.description, Constants.assignedUserValidUntilDescriptionCheck)
        XCTAssertEqual(mappedOwner?.mobileNumber, Constants.assignedUserMobileNumber)
        XCTAssertEqual(mappedOwner?.email, Constants.assignedUserEmail)
        XCTAssertEqual(mappedOwner?.displayName, Constants.assignedUserDisplayName)
        XCTAssertEqual(mappedOwner?.authorizationId, Constants.assignedUserAuthorizationId)
        XCTAssertEqual(mappedOwner?.userImageURL?.path, Constants.assignedUserImageUrl)
        XCTAssertEqual(mappedOwner?.status, Constants.assignedUserStatus)

        let mappedUsers = mappedUserManagementModel.users
        XCTAssertEqual(mappedUsers?.count, 1)
        let mappedUser = mappedUsers?.first
        XCTAssertNotNil(mappedUser)
        XCTAssertEqual(mappedUser?.validUntil?.description, Constants.assignedUserValidUntilDescriptionCheck)
        XCTAssertEqual(mappedUser?.mobileNumber, Constants.assignedUserMobileNumber)
        XCTAssertEqual(mappedUser?.email, Constants.assignedUserEmail)
        XCTAssertEqual(mappedUser?.displayName, Constants.assignedUserDisplayName)
        XCTAssertEqual(mappedUser?.authorizationId, Constants.assignedUserAuthorizationId)
        XCTAssertEqual(mappedUser?.userImageURL?.path, Constants.assignedUserImageUrl)
        XCTAssertEqual(mappedUser?.status, Constants.assignedUserStatus)
    }

    func testMapUserManagement() {
		
        let metaDataModel = UserManagementMetaDataModel(maxProfileNumber: Constants.maxProfileNumber,
														occupiedProfilesNumber: Constants.occupiedProfilesNumber,
														profileSyncStatus: Constants.profileSyncStatus)
        let owner = VehicleAssignedUserModel(authorizationId: Constants.assignedUserAuthorizationId,
											 displayName: Constants.assignedUserDisplayName,
											 email: Constants.assignedUserEmail,
											 mobileNumber: Constants.assignedUserMobileNumber,
											 status: Constants.assignedUserStatus,
											 userImageURL: Constants.assignedUserImageUrl,
											 validUntil: DateFormattingHelper.date(Constants.assignedUserValidUntil,
																				   format: DateFormat.iso8601))
        let userManagementModel = VehicleUserManagementModel(finOrVin: Constants.finOrVin,
															 metaData: metaDataModel,
															 owner: owner,
															 users: [owner],
															 unassignedProfiles: [])
		let mappedUserManagementModel = self.mapper.map(userManagementModel)
		mappedUserManagementModel.finOrVin = Constants.finOrVin
        XCTAssertEqual(mappedUserManagementModel.finOrVin, Constants.finOrVin)

        let mappedMetaDataModel = mappedUserManagementModel.metaData
        XCTAssertNotNil(mappedMetaDataModel)
        XCTAssertEqual(mappedMetaDataModel?.occupiedProfilesNumber, Constants.occupiedProfilesNumber)
        XCTAssertEqual(mappedMetaDataModel?.maxProfileNumber, Constants.maxProfileNumber)
        XCTAssertEqual(mappedMetaDataModel?.profileSyncStatus, Constants.profileSyncStatus.rawValue)

        let mappedOwner = mappedUserManagementModel.owner
        XCTAssertNotNil(mappedOwner)
        XCTAssertEqual(DateFormattingHelper.date(mappedOwner?.validUntil,
												 format: DateFormat.iso8601)?.description,
					   Constants.assignedUserValidUntilDescriptionCheck)
        XCTAssertEqual(mappedOwner?.status, Constants.assignedUserStatus.rawValue)
        XCTAssertEqual(mappedOwner?.authorizationId, Constants.assignedUserAuthorizationId)
        XCTAssertEqual(mappedOwner?.displayName, Constants.assignedUserDisplayName)
        XCTAssertEqual(mappedOwner?.email, Constants.assignedUserEmail)
        XCTAssertEqual(mappedOwner?.mobileNumber, Constants.assignedUserMobileNumber)
        XCTAssertEqual(mappedOwner?.userImageUrl, Constants.assignedUserImageUrl)

        let mappedUsers = mappedUserManagementModel.users
        XCTAssertEqual(mappedUsers.count, 1)
        let mappedUser = mappedUsers.first
        XCTAssertNotNil(mappedUser)
        XCTAssertEqual(DateFormattingHelper.date(mappedUser?.validUntil,
												 format: DateFormat.iso8601)?.description,
					   Constants.assignedUserValidUntilDescriptionCheck)
        XCTAssertEqual(mappedUser?.status, Constants.assignedUserStatus.rawValue)
        XCTAssertEqual(mappedUser?.authorizationId, Constants.assignedUserAuthorizationId)
        XCTAssertEqual(mappedUser?.displayName, Constants.assignedUserDisplayName)
        XCTAssertEqual(mappedUser?.email, Constants.assignedUserEmail)
        XCTAssertEqual(mappedUser?.mobileNumber, Constants.assignedUserMobileNumber)
        XCTAssertEqual(mappedUser?.userImageUrl, Constants.assignedUserImageUrl)
    }

	
    // MARK: - Helpers

    private func createDBMetaDataModel() -> DBUserManagementMetaDataModel {
		
        let metaDataModel = DBUserManagementMetaDataModel()
        metaDataModel.occupiedProfilesNumber = Constants.occupiedProfilesNumber
        metaDataModel.maxProfileNumber = Constants.maxProfileNumber
        metaDataModel.profileSyncStatus = Constants.profileSyncStatus.rawValue
        return metaDataModel
    }

    private func createDBAssignedUserModel() -> DBVehicleAssignedUserModel {
		
        let assignedUserModel = DBVehicleAssignedUserModel()
        assignedUserModel.status = Constants.assignedUserStatus.rawValue
        assignedUserModel.authorizationId = Constants.assignedUserAuthorizationId
        assignedUserModel.displayName = Constants.assignedUserDisplayName
        assignedUserModel.email = Constants.assignedUserEmail
        assignedUserModel.mobileNumber = Constants.assignedUserMobileNumber
        assignedUserModel.userImageUrl = Constants.assignedUserImageUrl
        assignedUserModel.validUntil = Constants.assignedUserValidUntil
        return assignedUserModel
    }
}
