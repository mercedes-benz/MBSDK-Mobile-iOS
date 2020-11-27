//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Violation type of the valet protect
public enum ValetProtectViolationType: String, Codable {
    case ignitionOn = "IGNITION_ON"
    case ignitionOff = "IGNITION_OFF"
    case fence = "FENCE"
}
