//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// The capabilities of head unit
public enum HuCapability: String, Codable, CaseIterable {
	case dynamicRoute
	case singlePOI
	case staticRoute
}
