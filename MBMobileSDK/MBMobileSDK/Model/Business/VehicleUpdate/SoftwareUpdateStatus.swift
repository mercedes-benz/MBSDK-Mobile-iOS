//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - SoftwareUpdateStatus
public enum SoftwareUpdateStatus: String, Codable {
    case pending = "PENDING"
    case successful = "SUCCESSFUL"
    case failed = "FAILED"
    case canceled = "CANCELED"
}
