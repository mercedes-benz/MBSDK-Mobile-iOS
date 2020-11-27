//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIHuCapabilityModel: Codable {
	let capabilities: [HuCapability]
	
	
	// MARK: - Init
	
	init(from decoder: Decoder) throws {
		
		let container     = try decoder.container(keyedBy: CodingKeys.self)
		self.capabilities = container.decodeArraySafelyIfPresent(HuCapability.self, forKey: .capabilities) ?? []
	}
}
