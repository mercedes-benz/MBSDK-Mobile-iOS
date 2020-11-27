//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

/// Status of the profile sync
public enum ProfileSyncStatus: String, Codable {
    case on = "ON"
    case off = "OFF"
    case manageInHeadUnit = "MANAGE_IN_HEAD_UNIT"
    case serviceNotActive = "SERVICE_NOT_ACTIVE"
    case unsupported = "UNSUPPORTED"
    case unknown = "UNKNOWN"
}
