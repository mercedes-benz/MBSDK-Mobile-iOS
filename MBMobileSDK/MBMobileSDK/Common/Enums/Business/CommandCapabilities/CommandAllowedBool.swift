//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// The allowed bool of a command capability
public enum CommandAllowedBool: String {
	case onlyFalse = "ONLY_FALSE"
	case onlyTrue = "ONLY_TRUE"
	case trueAndFalse = "TRUE_AND_FALSE"
	case unknown
}
