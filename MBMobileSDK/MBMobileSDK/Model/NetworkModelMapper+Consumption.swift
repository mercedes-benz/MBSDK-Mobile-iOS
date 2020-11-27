//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - Consumption

extension NetworkModelMapper {
	
	// MARK: - BusinessModel
	
	static func map(apiVehicleConsumptionModel: APIVehicleConsumptionModel) -> ConsumptionModel {
		return ConsumptionModel(averageConsumption: self.map(apiVehicleConsumptionEntryModel: apiVehicleConsumptionModel.averageConsumption),
								consumptionData: self.map(apiVehicleConsumptionDataModel: apiVehicleConsumptionModel.consumptionData),
                                individual30DaysConsumption: self.map(apiVehicleConsumptionIndividual30DaysModel: apiVehicleConsumptionModel.individual30DaysConsumption),
								individualLifetimeConsumption: self.map(apiVehicleConsumptionEntryModel: apiVehicleConsumptionModel.individualLifetimeConsumption),
								individualResetConsumption: self.map(apiVehicleConsumptionEntryModel: apiVehicleConsumptionModel.individualResetConsumption),
								individualStartConsumption: self.map(apiVehicleConsumptionEntryModel: apiVehicleConsumptionModel.individualStartConsumption),
								wltpCombined: self.map(apiVehicleConsumptionEntryModel: apiVehicleConsumptionModel.wltpCombined))
	}
	
	
	// MARK: - Helper
	
	private static func map(apiVehicleConsumptionDataModel: APIVehicleConsumptionDataModel?) -> ConsumptionDataModel {
		
		let value = apiVehicleConsumptionDataModel?.value.map { self.map(apiVehicleConsumptionValueModel: $0) } ?? []
		return ConsumptionDataModel(changed: apiVehicleConsumptionDataModel?.changed ?? false,
									value: value)
	}
	
	private static func map(apiVehicleConsumptionEntryModel: APIVehicleConsumptionEntryModel?) -> ConsumptionEntryModel? {
		
		guard let apiVehicleConsumptionEntryModel = apiVehicleConsumptionEntryModel else {
			return nil
		}
		return ConsumptionEntryModel(changed: apiVehicleConsumptionEntryModel.changed ?? false,
									 unit: apiVehicleConsumptionEntryModel.unit,
									 value: apiVehicleConsumptionEntryModel.value)
	}
	
	private static func map(apiVehicleConsumptionIndividual30DaysModel: APIVehicleConsumptionIndividual30DaysModel?) -> ConsumptionIndividual30DaysModel? {
		
		guard let apiVehicleConsumptionIndividual30DaysModel = apiVehicleConsumptionIndividual30DaysModel else {
			return nil
        }
        return ConsumptionIndividual30DaysModel(lastUpdated: apiVehicleConsumptionIndividual30DaysModel.lastUpdated,
                                                unit: apiVehicleConsumptionIndividual30DaysModel.unit,
												value: apiVehicleConsumptionIndividual30DaysModel.value)
    }
	
	private static func map(apiVehicleConsumptionValueModel: APIVehicleConsumptionValueModel) -> ConsumptionValueModel {
		return ConsumptionValueModel(consumption: apiVehicleConsumptionValueModel.consumption,
									 group: apiVehicleConsumptionValueModel.group ?? 0,
									 percentage: apiVehicleConsumptionValueModel.percentage,
									 unit: apiVehicleConsumptionValueModel.unit)
	}
}
