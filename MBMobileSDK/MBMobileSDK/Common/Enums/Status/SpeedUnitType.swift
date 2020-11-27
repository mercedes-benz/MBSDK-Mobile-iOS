//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// State for speed unit attribute
public enum SpeedUnitType: Bool, Codable, CaseIterable {
	case km = 0
	case miles = 1
}

// MARK: - Extension

extension SpeedUnitType {
	
	public var toString: String {
		switch self {
		case .km:		return "km"
		case .miles:	return "miles"
		}
	}
}
