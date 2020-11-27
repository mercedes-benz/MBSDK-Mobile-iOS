//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIVehicleConsumptionIndividual30DaysModel: Decodable {
	
    let lastUpdated: Int?
	let unit: ConsumptionUnit
    let value: Double
}
