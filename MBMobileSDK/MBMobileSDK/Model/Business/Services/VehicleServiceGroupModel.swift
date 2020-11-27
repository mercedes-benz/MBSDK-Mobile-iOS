//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of a service activation group
public struct VehicleServiceGroupModel {
	
	public let group: String
	public let services: [VehicleServiceModel]
	
	
	// MARK: - Init
	
	public init(group: String, services: [VehicleServiceModel]) {
		
		self.group = group
		self.services = services
	}
}


// MARK: - VehicleServiceGroup

public struct VehicleServiceGroup {
	
	public let group: String
	public let provider: ResultsServicesProvider?
	
	
	// MARK: - Init
	
	public init(group: String, provider: ResultsServicesProvider?) {
		
		self.group = group
		self.provider = provider
	}
}
