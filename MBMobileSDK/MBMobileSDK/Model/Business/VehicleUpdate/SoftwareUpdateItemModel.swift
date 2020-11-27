//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - SoftwareUpdateItemModel
public struct SoftwareUpdateItemModel {
    /// Localized title of the campaign/software update item
    public let title: String
    /// Localized short description of the campaign/software update item
    public let description: String
    /// Issuing timestamp of the campaign/software update item
    public let timestamp: Date?
    /// Current status of the update operation
    public let status: SoftwareUpdateStatus?
}
