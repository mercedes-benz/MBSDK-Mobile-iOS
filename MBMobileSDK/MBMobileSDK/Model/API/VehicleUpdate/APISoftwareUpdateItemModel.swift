//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation


// MARK: - APISoftwareUpdateItemModel
struct APISoftwareUpdateItemModel: Codable {
    let title: String
    let description: String
    let timestamp: String?
    let status: SoftwareUpdateStatus?
}
