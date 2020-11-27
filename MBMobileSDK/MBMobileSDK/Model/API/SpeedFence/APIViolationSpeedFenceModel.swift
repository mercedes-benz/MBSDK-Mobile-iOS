//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

struct APIViolationSpeedFenceModel: Decodable {
    let armtype: Int
    let endtime: Int
    let geofenceid: Int?
    let speedfenceid: Int
    let threshold: Int
    let trigger: Int?
    let violationdelay: Int
}
