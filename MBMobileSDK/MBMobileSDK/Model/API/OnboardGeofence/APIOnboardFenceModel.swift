//
//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - APIOnboardFenceModel
struct APIOnboardFenceModel: Codable {
    let geofenceid: Int?
    let name: String?
    let isActive: Bool?
    let center: CoordinateModel?
    let fencetype: FenceTypeModel?
    let radiusInMeter: Int?
    let verticescount: Int?
    let verticespositions: [CoordinateModel]?
    let syncstatus: GeofenceSyncStatus?
}
