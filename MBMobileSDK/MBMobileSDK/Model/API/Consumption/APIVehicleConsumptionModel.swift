//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIVehicleConsumptionModel: Decodable {
	
	let averageConsumption: APIVehicleConsumptionEntryModel?
	let consumptionData: APIVehicleConsumptionDataModel?
	let individual30DaysConsumption: APIVehicleConsumptionIndividual30DaysModel?
	let individualLifetimeConsumption: APIVehicleConsumptionEntryModel?
	let individualResetConsumption: APIVehicleConsumptionEntryModel?
	let individualStartConsumption: APIVehicleConsumptionEntryModel?
	let wltpCombined: APIVehicleConsumptionEntryModel?
}
