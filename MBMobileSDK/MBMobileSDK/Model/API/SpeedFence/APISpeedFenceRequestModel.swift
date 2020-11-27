//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

struct APISpeedFenceRequestModel: Encodable {
    let speedfenceid: Int?
    let geofenceid: Int?
    let name: String?
    let isActive: Bool
    let endtime: Int
    let threshold: Int
    let unit: String?
    let violationdelay: Int
    let violationtype: ViolationType?
}
