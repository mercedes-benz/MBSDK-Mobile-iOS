//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIVehicleConsumptionEntryModel: Decodable {

	let changed: Bool?
	let unit: ConsumptionUnit
	let value: Double
}
