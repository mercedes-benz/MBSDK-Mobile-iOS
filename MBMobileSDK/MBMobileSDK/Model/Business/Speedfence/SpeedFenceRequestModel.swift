//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of the speed fence request
public struct SpeedFenceRequestModel {
    
    let speedfenceId: Int?
    let geofenceId: Int?
    let name: String?
    let isActive: Bool
    let endTime: Int
    let threshold: Int
    let unit: SpeedUnit?
    let violationDelay: Int
	let violationType: ViolationType?
}

public extension SpeedFenceRequestModel {
	
    // swiftlint:disable function_parameter_count
    static func create(geofenceId: Int?,
                       name: String?,
                       isActive: Bool,
                       endTime: Int,
                       threshold: Int,
                       unit: SpeedUnit?,
                       violationDelay: Int,
                       violationType: ViolationType?) -> SpeedFenceRequestModel {
        
        return SpeedFenceRequestModel(speedfenceId: nil,
                                      geofenceId: geofenceId,
                                      name: name,
                                      isActive: isActive,
                                      endTime: endTime,
                                      threshold: threshold,
                                      unit: unit,
                                      violationDelay: violationDelay,
                                      violationType: violationType)
    }
    
    static func update(speedfenceId: Int,
                       geofenceId: Int?,
                       name: String?,
                       isActive: Bool,
                       endTime: Int,
                       threshold: Int,
                       unit: SpeedUnit?,
                       violationDelay: Int,
                       violationType: ViolationType?) -> SpeedFenceRequestModel {
        
        return SpeedFenceRequestModel(speedfenceId: speedfenceId,
                                      geofenceId: geofenceId,
                                      name: name,
                                      isActive: isActive,
                                      endTime: endTime,
                                      threshold: threshold,
                                      unit: unit,
                                      violationDelay: violationDelay,
                                      violationType: violationType)
    }
    // swiftlint:enable function_parameter_count
}
