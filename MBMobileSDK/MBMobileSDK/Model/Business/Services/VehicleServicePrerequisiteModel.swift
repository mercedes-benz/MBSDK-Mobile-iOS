//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - Deprecated

/// Representation of prerequisite for a vehicle service
@available(*, deprecated, message: "VehicleServicePrerequisiteModel is deprecated.")
public struct VehicleServicePrerequisiteModel {
	
	public let actions: [ServiceAction]
	public let missingFields: [ServiceMissingFields]
	public let name: PrerequisiteCheck
}
