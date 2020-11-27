//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

public struct APIUserUnitPreferenceModel: Codable {
	
	let clockHours: ClockHoursUnit
	let consumptionCo: ConsumptionCoUnit
	let consumptionEv: ConsumptionEvUnit
	let consumptionGas: ConsumptionGasUnit
	let speedDistance: SpeedDistanceUnit
	let temperature: UserTemperatureUnit
	let tirePressure: TirePressureUnit
	
	
	// MARK: - Init
	
	public init(from decoder: Decoder) throws {

		let container       = try decoder.container(keyedBy: CodingKeys.self)

		self.clockHours     = container.decodeSafelyIfPresent(ClockHoursUnit.self, forKey: .clockHours) ?? ClockHoursUnit.defaultCase
		self.consumptionCo  = container.decodeSafelyIfPresent(ConsumptionCoUnit.self, forKey: .consumptionCo) ?? ConsumptionCoUnit.defaultCase
		self.consumptionEv  = container.decodeSafelyIfPresent(ConsumptionEvUnit.self, forKey: .consumptionEv) ?? ConsumptionEvUnit.defaultCase
		self.consumptionGas = container.decodeSafelyIfPresent(ConsumptionGasUnit.self, forKey: .consumptionGas) ?? ConsumptionGasUnit.defaultCase
		self.speedDistance  = container.decodeSafelyIfPresent(SpeedDistanceUnit.self, forKey: .speedDistance) ?? SpeedDistanceUnit.defaultCase
		self.temperature    = container.decodeSafelyIfPresent(UserTemperatureUnit.self, forKey: .temperature) ?? UserTemperatureUnit.defaultCase
		self.tirePressure   = container.decodeSafelyIfPresent(TirePressureUnit.self, forKey: .tirePressure) ?? TirePressureUnit.defaultCase
	}
	
	public init(
		clockHours: ClockHoursUnit?,
		consumptionCo: ConsumptionCoUnit?,
		consumptionEv: ConsumptionEvUnit?,
		consumptionGas: ConsumptionGasUnit?,
		speedDistance: SpeedDistanceUnit?,
		temperature: UserTemperatureUnit?,
		tirePressure: TirePressureUnit?) {
		
		self.clockHours     = clockHours ?? ClockHoursUnit.defaultCase
		self.consumptionCo  = consumptionCo ?? ConsumptionCoUnit.defaultCase
		self.consumptionEv  = consumptionEv ?? ConsumptionEvUnit.defaultCase
		self.consumptionGas = consumptionGas ?? ConsumptionGasUnit.defaultCase
		self.speedDistance  = speedDistance ?? SpeedDistanceUnit.defaultCase
		self.temperature    = temperature ?? UserTemperatureUnit.defaultCase
		self.tirePressure   = tirePressure ?? TirePressureUnit.defaultCase
	}
}
