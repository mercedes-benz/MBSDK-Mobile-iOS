//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// TCU hardware version of the vehicle
public enum TcuHardwareVersion: String, Codable {
	case hermes1 = "Hermes1"
	case hermes1x5 = "Hermes1.5"
	case hermes2 = "Hermes2"
	case hermes2x1 = "Hermes2.1"
	case hermesFup1 = "HermesFup1"
	case hermesFup2 = "HermesFup2"
	case kom = "KOM"
	case none = "NoTCU"
	case ramses = "Ramses"
	case unknown
}
