//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - CustomerFenceModel
public struct CustomerFenceModel {
    
    let customerfenceid: Int?
    let geofenceid: Int?
    /// User defined name of the fence (max. 128 characters)
    let name: String?
    let days: [GeofenceWeekday]?
    /// Minutes from midnight (range: 0.. 1439). If begin > end, a midnight overlap is assumed (e.g., 23h-02h).
    let beginMinutes: Int?
    /// Minutes from midnight (range: 0..1439). If begin > end, a midnight overlap is assumed (e.g., 23h-02h).
    let endMinutes: Int?
    /// UTC timestamp in seconds (ISO 9945)
    let timestamp: Int?
    let violationtype: ViolationType?
}

public extension CustomerFenceModel {
    static func create(geofenceid: Int?,
                       name: String?,
                       days: [GeofenceWeekday]?,
                       beginMinutes: Int?,
                       endMinutes: Int?,
                       violationtype: ViolationType?) -> CustomerFenceModel {
        CustomerFenceModel(customerfenceid: nil,
                           geofenceid: geofenceid,
                           name: name,
                           days: days,
                           beginMinutes: beginMinutes,
                           endMinutes: endMinutes,
                           timestamp: nil,
                           violationtype: violationtype)
    }
    
    static func update(customerfenceid: Int?,
                       geofenceid: Int?,
                       name: String?,
                       days: [GeofenceWeekday]?,
                       beginMinutes: Int?,
                       endMinutes: Int?,
                       violationtype: ViolationType?) -> CustomerFenceModel {
        CustomerFenceModel(customerfenceid: customerfenceid,
                           geofenceid: customerfenceid,
                           name: name,
                           days: days,
                           beginMinutes: beginMinutes,
                           endMinutes: endMinutes,
                           timestamp: nil,
                           violationtype: violationtype)
    }
}
