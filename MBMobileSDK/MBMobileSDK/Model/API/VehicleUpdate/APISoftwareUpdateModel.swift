//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - APISoftwareUpdateModel
struct APISoftwareUpdateModel: Codable {
    let totalUpdates: Int
    let availableUpdates: Int
    let lastSynchronization: String?
    let updates: [APISoftwareUpdateItemModel]
}
