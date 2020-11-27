//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - TimeFormatType

/// State for time format attribute
public enum TimeFormatType: Bool, Codable, CaseIterable {
	case format12 = 0
	case format24 = 1
}

extension TimeFormatType {
	
	public var toString: String {
		switch self {
		case .format12:	return "12 h"
		case .format24:	return "24 h"
		}
	}
}


// MARK: - TimeType

/// State for time type attribute
public enum TimeType: Bool, CaseIterable {
	case absolute = 0
	case relative = 1
}

extension TimeType {
	
	public var toString: String {
		switch self {
		case .absolute:		return "absolute time"
		case .relative:		return "relatve time"
		}
	}
}
