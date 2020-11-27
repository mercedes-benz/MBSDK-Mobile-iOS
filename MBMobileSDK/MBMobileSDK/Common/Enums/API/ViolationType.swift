//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Violation type for geofence
public enum ViolationType: String, CaseIterable, Codable {
    case leave = "LEAVE"
    case enter = "ENTER"
    case leaveAndEnter = "LEAVE_AND_ENTER"
}
