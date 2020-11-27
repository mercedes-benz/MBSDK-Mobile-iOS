//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of a consumption
public struct ConsumptionModel {
	
	public let averageConsumption: ConsumptionEntryModel?
	public let consumptionData: ConsumptionDataModel?
	public let individual30DaysConsumption: ConsumptionIndividual30DaysModel?
	public let individualLifetimeConsumption: ConsumptionEntryModel?
	public let individualResetConsumption: ConsumptionEntryModel?
	public let individualStartConsumption: ConsumptionEntryModel?
	public let wltpCombined: ConsumptionEntryModel?
}
