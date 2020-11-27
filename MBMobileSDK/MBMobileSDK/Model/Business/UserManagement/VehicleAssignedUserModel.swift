//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of the assigned user in the vehicle
public struct VehicleAssignedUserModel {
	public let authorizationId: String
	public let displayName: String
	public let email: String?
	public let mobileNumber: String?
	public let status: VehicleAssignedUserStatus
	private let userImageURLString: String?
    public let validUntil: Date?
	

	// MARK: - Init
	
	public init(
		authorizationId: String,
		displayName: String,
		email: String?,
		mobileNumber: String?,
		status: VehicleAssignedUserStatus,
		userImageURL: String?,
		validUntil: Date?) {
        
		self.authorizationId = authorizationId
		self.displayName = displayName
		self.email = email
		self.mobileNumber = mobileNumber
		self.status = status
		self.userImageURLString = userImageURL
        self.validUntil = validUntil
	}
}


// MARK: - Extension

extension VehicleAssignedUserModel {
	
	public var userImageURL: URL? {
		guard let urlString = self.userImageURLString else {
			return nil
		}
		return URL(string: urlString)
	}
}
