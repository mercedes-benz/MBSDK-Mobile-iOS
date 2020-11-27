//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of user preferred units
public struct UserUnitPreferenceModel: Equatable {
	
	public let clockHours: ClockHoursUnit
	public let consumptionCo: ConsumptionCoUnit
	public let consumptionEv: ConsumptionEvUnit
	public let consumptionGas: ConsumptionGasUnit
	public let speedDistance: SpeedDistanceUnit
	public let temperature: UserTemperatureUnit
	public let tirePressure: TirePressureUnit
	
	
	// MARK: - Init
	
	public init(
		clockHours: ClockHoursUnit = ClockHoursUnit.defaultCase,
		consumptionCo: ConsumptionCoUnit = ConsumptionCoUnit.defaultCase,
		consumptionEv: ConsumptionEvUnit = ConsumptionEvUnit.defaultCase,
		consumptionGas: ConsumptionGasUnit = ConsumptionGasUnit.defaultCase,
		speedDistance: SpeedDistanceUnit = SpeedDistanceUnit.defaultCase,
		temperature: UserTemperatureUnit = UserTemperatureUnit.defaultCase,
		tirePressure: TirePressureUnit = TirePressureUnit.defaultCase) {
		
		self.clockHours     = clockHours
		self.consumptionCo  = consumptionCo
		self.consumptionEv  = consumptionEv
		self.consumptionGas = consumptionGas
		self.speedDistance  = speedDistance
		self.temperature    = temperature
		self.tirePressure   = tirePressure
	}
}
