//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// State for starter battery attribute
public enum StarterBatteryState: Int, Codable, CaseIterable {
	case green = 0
	case yellow = 1
	case red = 2
	case serviceDisabled = 3
	case vehicleNotAvailable = 4
}


// MARK: - Extension

extension StarterBatteryState {
	
	public var toString: String {
		switch self {
		case .green:				return "Vehicle ok"
		case .red:					return "Vehicle not available"
		case .serviceDisabled:		return "Remote service disabled"
		case .vehicleNotAvailable:	return "Vehicle no longer available"
		case .yellow:				return "Battery partly charged"
		}
	}
}
