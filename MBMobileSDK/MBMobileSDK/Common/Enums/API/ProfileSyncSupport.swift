//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

/// The Support state of the profile sync
public enum ProfileSyncSupport: String, Codable {
    case supported = "SUPPORTED"
    case manageInHeadUnit = "MANAGE_IN_HEAD_UNIT"
    case serviceNotActive = "SERVICE_NOT_ACTIVE"
    case unsupported = "UNSUPPORTED"
    case unknown = "UNKNOWN"
}
