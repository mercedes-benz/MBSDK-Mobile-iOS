//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of temperature point
public struct TemperaturePointModel {
	
    /// Temperature in °C
	public let temperatureInCelsius: Double
    /// Temperature zone in car
	public let zone: TemperatureZone
	
	
	// MARK: - Init
	
	public init(temperatureInCelsius: Double, zone: TemperatureZone) {
		
		self.temperatureInCelsius = temperatureInCelsius
		self.zone = zone
	}
}
