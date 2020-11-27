//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - ChargeProgram

/// The charge program according to which the HV battery of the vehicle should be charged.

public enum ChargeProgram: Int, CaseIterable {
    case `default` = 0
	case home = 2
	case work = 3
}
