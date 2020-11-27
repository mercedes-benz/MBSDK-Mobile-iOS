//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIVehicleConsumptionDataModel: Decodable {
	
	let changed: Bool?
	let value: [APIVehicleConsumptionValueModel]
}
