//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// State for temperature unit
public enum UserTemperatureUnit: String, Codable {
	case celsius = "Celsius"
	case fahrenheit = "Fahrenheit"
}


// MARK: - Extension

extension UserTemperatureUnit {
	
	public static var defaultCase: UserTemperatureUnit {
		return .celsius
	}
}
