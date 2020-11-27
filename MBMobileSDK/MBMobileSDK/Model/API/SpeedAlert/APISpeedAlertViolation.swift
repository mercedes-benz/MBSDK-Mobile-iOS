//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APISpeedAlertViolation: Decodable {
    let id: Int
    let time: Int
    let speedalertTreshold: Int
    let speedalertEndtime: Int
    let coordinates: APISpeedAlertCoordinates
}
