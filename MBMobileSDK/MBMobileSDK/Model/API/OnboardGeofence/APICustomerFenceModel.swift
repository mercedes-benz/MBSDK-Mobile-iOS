//
//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - APICustomerFenceModel
struct APICustomerFenceModel: Codable {
    let customerfenceid: Int?
    let geofenceid: Int?
    let name: String?
    let days: [GeofenceWeekday]?
    let beginMinutes: Int?
    let endMinutes: Int?
    let ts: Int?
    let violationtype: ViolationType?
}
