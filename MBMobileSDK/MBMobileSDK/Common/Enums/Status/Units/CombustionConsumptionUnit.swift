//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// State for combustion consumption unit
public enum CombustionConsumptionUnit: Int, Codable, CaseIterable {
	
	/// Liter per 100 km
	case literPer100Km = 1
	
	/// Kilometers per liter
	case kmPerLiter = 2
	
	/// Miles Per imperial gallon
	case mpgUk = 3
	
	/// Miles Per US gallon
	case mpgUs = 4
}
