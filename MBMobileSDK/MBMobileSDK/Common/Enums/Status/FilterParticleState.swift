//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// State for filter particle loading attribute
public enum FilterParticleState: Int, Codable, CaseIterable {
	case high = 0
	case medium = 1
	case low = 2
}


// MARK: - Extension

extension FilterParticleState {
	
	public var toString: String {
		switch self {
		case .high:		return "Air quality high"
		case .low:		return "Air quality low"
		case .medium:	return "Air quality medium"
		}
	}
}
