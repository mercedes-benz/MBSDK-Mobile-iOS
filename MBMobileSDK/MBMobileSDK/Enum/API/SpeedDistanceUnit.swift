//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// State for speed distance unit
public enum SpeedDistanceUnit: String, Codable {
    
    /// km/h, distance unit: km
	case kilometers = "km/h, km"
    /// mph, distance unit: miles
	case miles = "mph, mi"
}


// MARK: - Extension

extension SpeedDistanceUnit {
	
	public static var defaultCase: SpeedDistanceUnit {
		return .kilometers
	}
}
