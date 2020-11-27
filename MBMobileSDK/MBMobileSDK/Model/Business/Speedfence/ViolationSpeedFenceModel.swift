//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

public struct ViolationSpeedFenceModel {
    public let armType: Int
    public let endTime: Int
    public let geofenceId: Int?
    public let speedfenceId: Int
    public let threshold: Int
    public let trigger: Int?
    public let violationDelay: Int
}
