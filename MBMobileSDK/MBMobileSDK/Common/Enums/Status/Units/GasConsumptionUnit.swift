//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// State for gas consumption unit
public enum GasConsumptionUnit: Int, Codable, CaseIterable {
	
	/// kg per 100 km
	case kgPer100Km = 1
	
	/// km per kg
	case kmPerKg = 2
	
	/// miles per kg
	case mPerKg = 3
}
