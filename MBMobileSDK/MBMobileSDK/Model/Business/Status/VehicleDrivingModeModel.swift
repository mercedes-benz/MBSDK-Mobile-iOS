//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public struct VehicleDrivingModeModel {
    
    /// Current state of teenage driving mode
    public let teenage: StatusAttributeType<DrivingModeStatus, NoUnit>
    /// Current state of valet driving mode
    public let valet: StatusAttributeType<DrivingModeStatus, NoUnit>
}

public enum DrivingModeStatus: Int, CaseIterable {
    case unknown = 0
    case off = 1
    case on = 2
    case pendingOff = 3
    case pendingOn = 4
    case error = 5
}
