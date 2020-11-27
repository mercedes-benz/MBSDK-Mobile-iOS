//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/**
ON: The profile sync is active, OFF: profile sync is inactive, ACTIVATE_IN_HEAD_UNIT: profile sync needs to enabled in head-unit (NTG5.5), UNSUPPORTED: head unit does not support profile sync
*/
public enum VehicleProfileSyncStatus: String {
	case on = "ON"
	case off = "OFF"
	case headUnitActivationNeeded = "ACTIVATE_IN_HEAD_UNIT"
    case serviceNotActive = "SERVICE_NOT_ACTIVE"
	case unsupported = "UNSUPPORTED"
    case unknown = "UNKNOWN"
}
