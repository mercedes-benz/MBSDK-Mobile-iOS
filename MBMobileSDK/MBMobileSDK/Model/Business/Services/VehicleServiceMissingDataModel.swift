//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of the missing data from a vehicle service
public struct VehicleServiceMissingDataModel {
	public let missingAccountLinkage: VehicleServiceAccountLinkageModel?
}


/// Representation of the account linkage from a vehicle service
public struct VehicleServiceAccountLinkageModel {
	public let accountType: AccountType
	public let mandatory: Bool
}
