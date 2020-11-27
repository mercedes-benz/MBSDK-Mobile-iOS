//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// State for attribute with low, medium, high
public enum LowMediumHighState: Int, Codable, CaseIterable {
	case low = 0
	case medium = 1
	case high = 2
}


// MARK: - Extension

extension LowMediumHighState {
	
	public var toString: String {
		switch self {
		case .high:		return "high"
		case .low:		return "low"
		case .medium:	return "medium"
		}
	}
}
