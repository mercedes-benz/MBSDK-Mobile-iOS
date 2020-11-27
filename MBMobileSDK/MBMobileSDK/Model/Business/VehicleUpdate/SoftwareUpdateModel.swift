//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - SoftwareUpdateModel
public struct SoftwareUpdateModel {
    /// Total count of all software updates for the vehicle (recent + available)
    public let totalUpdates: Int
    /// Count of available updates for the vehicle (not installed yet)
    public let availableUpdates: Int
    /// Timestamp of last synchronization of update campaigns for the vehicle
    public let lastSynchronization: Date?
    /// Array of SoftwareUpdateItemModel
    public let updates: [SoftwareUpdateItemModel]
}
