//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// State for roof top attribute
public enum RoofTopState: Int, Codable, CaseIterable {
	case unlocked = 0
	case openLocked = 1
	case closeLocked = 2
}


// MARK: - Extension

extension RoofTopState {
	
	public var toString: String {
		switch self {
		case .closeLocked:	return "closed & locked"
		case .openLocked:	return "open & locked"
		case .unlocked:		return "unlocked"
		}
	}
}
