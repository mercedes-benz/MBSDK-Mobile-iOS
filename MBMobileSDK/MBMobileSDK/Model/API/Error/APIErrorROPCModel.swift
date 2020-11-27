//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBNetworkKit

struct APIErrorROPCModel: Decodable {
	
	let description: String
	let error: String
	
	enum CodingKeys: String, CodingKey {
		case description = "error_description"
		case error
	}
}


// MARK: - MBErrorConformable

extension APIErrorROPCModel: MBErrorConformable {
	
	public var errorDescription: String? {
		return self.error + " -> " + self.description
	}
}
