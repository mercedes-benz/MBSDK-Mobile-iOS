//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// State for electricity consumption unit
public enum ElectricityConsumptionUnit: Int, Codable, CaseIterable {
	
	/// kWh per 100 km
	case kwhPer100Km = 1
	
	/// Kilometers per kWh
	case kmPerKwh = 2
	
	/// kWh per 100 miles
	case kwhPer100Mi = 3
	
	/// miles per kWh
	case mPerKwh = 4
	
	/// Miles per gallon gasoline equivalent
	case mpge = 5
}
