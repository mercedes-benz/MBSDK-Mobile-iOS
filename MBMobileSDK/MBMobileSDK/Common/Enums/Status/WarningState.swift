//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Bool state for warning attributes
public enum WarningState: Bool, Codable, CaseIterable {
	case inactive = 0
	case triggered = 1
}


// MARK: - Extension

extension WarningState {
	
	public var toString: String {
		switch self {
		case .inactive:		return "inactive"
		case .triggered:	return "triggered"
		}
	}
}
