//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// State for consumption gas unit
public enum ConsumptionGasUnit: String, Codable {
	case kilogramPer100Kilometers = "kg/100km"
	case kilometersPerKilogram = "km/kg"
	case milesPerKilogram = "mpkg"
}


// MARK: - Extension

extension ConsumptionGasUnit {
	
	public static var defaultCase: ConsumptionGasUnit {
		return .kilogramPer100Kilometers
	}
}
