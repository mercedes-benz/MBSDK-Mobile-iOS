//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// State for temperature unit
public enum TemperatureUnit: Int, Codable, CaseIterable {
	
	/// Celsius
	case celsius = 1
	
	/// Fahrenheit
	case fahrenheit = 2
}
