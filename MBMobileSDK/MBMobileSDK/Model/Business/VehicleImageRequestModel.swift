//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct VehicleImageRequestModel: Codable {
	
	let background: String?
	let centered: Bool?
	let fallbackImage: Bool?
	let imageKeys: String?
	let night: Bool?
	let roofOpen: Bool?
}
