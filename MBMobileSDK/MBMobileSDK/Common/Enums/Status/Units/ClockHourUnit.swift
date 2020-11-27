//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// State for clock hours unit
public enum ClockHourUnit: Int, Codable, CaseIterable {
	
	/// 12h (AM/PM)
	case t12H = 1
	
	/// 24h
	case t24H = 2
}
