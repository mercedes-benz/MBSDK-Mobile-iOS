//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

// swiftlint:disable function_parameter_count

import Foundation

// MARK: - OnboardFenceModel
public struct OnboardFenceModel {
    let geofenceid: Int?
    /// User defined name of the fence (max. 128 characters)
    let name: String?
    let isActive: Bool?
    /// Center object for fence circle
    let center: CoordinateModel?
    let fencetype: FenceTypeModel?
    /// Radius of circle in meter
    let radiusInMeter: Int?
    /// Number of vertices (only if fencetype=polygon)
    let verticescount: Int?
    /// List of vertices
    let verticespositions: [CoordinateModel]?
    let syncstatus: GeofenceSyncStatus?
}

public extension OnboardFenceModel {
    static func create(name: String?,
                       isActive: Bool?,
                       center: CoordinateModel?,
                       fencetype: FenceTypeModel?,
                       radiusInMeter: Int?,
                       verticescount: Int?,
                       verticespositions: [CoordinateModel]?) -> OnboardFenceModel {
        return OnboardFenceModel(geofenceid: nil,
                                 name: name,
                                 isActive: isActive,
                                 center: center,
                                 fencetype: fencetype,
                                 radiusInMeter: radiusInMeter,
                                 verticescount: verticescount,
                                 verticespositions: verticespositions,
                                 syncstatus: nil)
    }
    
    static func update(geofenceid: Int?,
                       name: String?,
                       isActive: Bool?,
                       center: CoordinateModel?,
                       fencetype: FenceTypeModel?,
                       radiusInMeter: Int?,
                       verticescount: Int?,
                       verticespositions: [CoordinateModel]?) -> OnboardFenceModel {
        return OnboardFenceModel(geofenceid: geofenceid,
                                 name: name,
                                 isActive: isActive,
                                 center: center,
                                 fencetype: fencetype,
                                 radiusInMeter: radiusInMeter,
                                 verticescount: verticescount,
                                 verticespositions: verticespositions,
                                 syncstatus: nil)
    }
}
