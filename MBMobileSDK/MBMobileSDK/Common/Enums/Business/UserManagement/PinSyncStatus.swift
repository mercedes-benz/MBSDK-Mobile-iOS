//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

/// Status of the pin sync
public enum PinSyncStatus: String, Codable {
    case set = "SET"
    case notSet = "NOT_SET"
    case blocked = "BLOCKED"
    case pending = "PENDING"
    case notSupported = "NOT_SUPPORTED"
}
