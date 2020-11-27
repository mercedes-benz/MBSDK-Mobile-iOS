//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// State for distance unit
public enum DistanceUnit: Int, Codable, CaseIterable {
	
	/// km
	case kilometers = 1
	
	/// miles
	case miles = 2
}


// MARK: - Extension

extension DistanceUnit {
	
	public static func map(unit: String) -> DistanceUnit? {
		switch unit {
		case "KM":	return .kilometers
		case "MI":	return .miles
		default:	return nil
		}
	}
    
    public func mapToString() -> String {
        switch self {
        case .kilometers: return "KM"
        case .miles:      return "MI"
        }
    }
}
