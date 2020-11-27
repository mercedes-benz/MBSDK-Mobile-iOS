//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIVehicleConsumptionValueModel: Decodable {
	
	let consumption: Double
	let group: Int?
	let percentage: Double
	let unit: ConsumptionUnit
}
