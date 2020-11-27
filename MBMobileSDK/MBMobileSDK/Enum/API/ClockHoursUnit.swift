//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// State for clock hours unit
public enum ClockHoursUnit: String, Codable {
	case type12h = "12h (AM/PM)"
	case type24h = "24h"
}


// MARK: - Extension

extension ClockHoursUnit {
	
	public static var defaultCase: ClockHoursUnit {
		return .type24h
	}
}
