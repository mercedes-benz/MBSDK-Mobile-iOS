//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Bool state for skip range attributes
public enum RangeSkipStatus: Bool, Codable, CaseIterable {
	case display = 0
	case skip = 1
}


// MARK: - Extension

extension RangeSkipStatus {
	
	public var toString: String {
		switch self {
		case .display:	return "Display range"
		case .skip:		return "Skip range"
		}
	}
}
