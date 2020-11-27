//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APICommandParameterModel: Decodable {
	
	let allowedBools: String?
	let allowedEnums: [String]?
	let maxValue: Double?
	let minValue: Double?
	let parameterName: String?
	let steps: Double?
}
