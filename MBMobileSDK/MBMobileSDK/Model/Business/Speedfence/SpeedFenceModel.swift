//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

public struct SpeedFenceModel {
    public let geofenceId: Int?
    /// User defined name of the fence (max. 128 characters)
    public let name: String?
    public let isActive: Bool?
    /// UTC timestamp in seconds (ISO 9945)
    public let endTime: Int?
    /// Threshold is a value in (range: 0..511)
    public let threshold: Int?
    /// Delay in minutes
    public let violationDelay: Int?
    public let violationTypes: ViolationType?
    /// UTC timestamp in seconds (ISO 9945)
    public let timestamp: Int?
    public let speedfenceId: Int?
    public let syncStatus: GeofenceSyncStatus?
}
