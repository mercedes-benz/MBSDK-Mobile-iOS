//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

struct APISpeedFenceModel: Codable {
    let geofenceid: Int?
    let name: String?
    let isActive: Bool?
    let endtime: Int?
    let threshold: Int?
    let violationdelay: Int?
    let violationtype: ViolationType?
    let ts: Int?
    let speedfenceid: Int?
    let syncstatus: GeofenceSyncStatus?
}
