//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APICommandCapabilityModel: Decodable {
	
	let additionalInformation: [String]?
	let commandName: String?
	let isAvailable: Bool?
	let parameters: [APICommandParameterModel]?
}
