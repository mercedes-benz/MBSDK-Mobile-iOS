//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIViolation: Decodable {
    let id: Int
    let violationType: String
    let fenceID: Int
    let time: Int
    let coordinate: APICoordinateModel
    let geofence: APIGeofence
    
    enum CodingKeys: String, CodingKey {
        case id
        case violationType = "type"
        case fenceID = "fenceId"
        case geofence = "snapshot"
        case time, coordinate
    }
}
