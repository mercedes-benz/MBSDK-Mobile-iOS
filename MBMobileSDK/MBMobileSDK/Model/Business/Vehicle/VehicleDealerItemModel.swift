//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of a dealer item of a vehicle
public struct VehicleDealerItemModel {
	
	public let dealerId: String
	public let role: DealerRole
	public let merchant: DealerMerchantModel?
}


// MARK: - Equatable

extension VehicleDealerItemModel: Equatable {
	
	public static func == (lhs: VehicleDealerItemModel, rhs: VehicleDealerItemModel) -> Bool {
		return lhs.dealerId == rhs.dealerId &&
			lhs.role.rawValue == rhs.role.rawValue
	}
}


// MARK: - VehicleDealerUpdateModel

/// Representation of the dealer to update in the vehicle
public struct VehicleDealerUpdateModel {

	public let dealerId: String
	public let role: DealerRole

	// MARK: - Init

	public init(dealerId: String, role: DealerRole) {

		self.dealerId = dealerId
		self.role     = role
	}
}


// MARK: - APIVehicleDealerUpdateModel

public struct APIVehicleDealerUpdateModel: Codable {

	public let dealerId: String
	public let role: DealerRole
}
