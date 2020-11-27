//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// TCU software version of the vehicle
public enum TcuSoftwareVersion: String, Codable {
	case unknown
	case version24x6 = "24.6"
	case version24x7 = "24.7"
	case version25x1 = "25.1"
	case version25x4 = "25.4"
	case version30x4 = "30.4"
	case version31x5 = "31.5"
	case version43x1 = "43.1"
	case version44x2 = "44.2"
	case version45 = "45.0"
	case version46 = "46.0"
	case version211x1 = "211.1"
	case version216x4 = "216.4"
	case version216x5 = "216.5"
	case version218x2 = "218.2"
	case version218x4 = "218.4"
	case version218x5 = "218.5"
	case version218x5n = "218.5n"
	case version218x5p = "218.5p"
	case version218x6 = "218.6"
	case version220 = "220"
	case version318 = "318"
	case version319x3 = "319.3"
	case version321 = "321"
	case version322x6 = "322.6"
	case version322x8 = "322.8"
	case version322x9 = "322.9"
	case version333x1 = "333.1"
	case version333x5 = "333.5"
	case version334x2 = "334.2"
	case version355 = "355.0"
	case version356 = "356.0"
	case version408x3 = "408.3"
	case version409 = "409.X"
	case version50x = "50x.x"
}
