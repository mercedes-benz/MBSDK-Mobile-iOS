//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

public enum GeofenceSyncStatus: String, Codable {
    case awaitingVep = "AWAITING_VEP"
    case failed = "FAILED"
    case finished = "FINISHED"
    case hold = "HOLD"
    case pending = "PENDING"
    case timeout = "TIMEOUT"
}
