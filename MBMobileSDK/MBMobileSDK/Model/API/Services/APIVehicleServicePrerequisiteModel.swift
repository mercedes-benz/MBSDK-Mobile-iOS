//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIVehicleServicePrerequisiteModel: Codable {
	
	let actions: [String]
	let missingFields: [ServiceMissingFields]?
	let name: PrerequisiteCheck
	
	
	// MARK: - Init
	
	init(from decoder: Decoder) throws {
		
		let container      = try decoder.container(keyedBy: CodingKeys.self)
		
		self.actions       = container.decodeArraySafelyIfPresent(String.self, forKey: .actions) ?? []
		self.missingFields = container.decodeArraySafelyIfPresent(ServiceMissingFields.self, forKey: .missingFields) ?? []
		self.name          = try container.decode(PrerequisiteCheck.self, forKey: .name)
	}
}
