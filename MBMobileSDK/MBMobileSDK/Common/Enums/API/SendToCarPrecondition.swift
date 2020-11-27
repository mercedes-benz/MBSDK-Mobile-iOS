//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

public enum SendToCarPrecondition: String, CaseIterable, Codable, CustomStringConvertible {
	case registerUser = "MBAPPS_REGISTER_USER"
	case enableMBApps = "MBAPPS_ENABLE_MBAPPS"
}

extension SendToCarPrecondition {
	
	public var description: String {
		switch self {
		case .enableMBApps:		return "enable mbApps"
		case .registerUser:		return "register user"
		}
	}
}
