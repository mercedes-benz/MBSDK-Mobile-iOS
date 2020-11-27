//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// State for consumption co unit
public enum ConsumptionCoUnit: String, Codable {
	case kilometersPerLiter = "km/l"
	case litersPer100Kilometers = "l/100km"
	case milesPerGallonUK = "mpg (UK)"
	case milesPerGallonUS = "mpg (US)"
}


// MARK: - Extension

extension ConsumptionCoUnit {
	
	public static var defaultCase: ConsumptionCoUnit {
		return .litersPer100Kilometers
	}
}
