//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// State for consumption ev unit
public enum ConsumptionEvUnit: String, Codable {
	case kilometersPerKilowattHour = "km/kWh"
	case kilowattHoursPer100Kilometers = "kWh/100km"
	case kilowattHoursPer100Miles = "kWh/100mi"
	case milesPerGallonGasolineEquivalent = "mpge"
	case milesPerKilowattHour = "mpkWh"
}


// MARK: - Extension

extension ConsumptionEvUnit {
	
	public static var defaultCase: ConsumptionEvUnit {
		return .kilowattHoursPer100Kilometers
	}
}
