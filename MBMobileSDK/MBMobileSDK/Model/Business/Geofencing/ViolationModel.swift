//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of geofence violation
public struct ViolationModel {
    
    public let id: Int
    public let violationType: ViolationType
    public let fenceId: Int
    public let time: Int
    public let coordinate: CoordinateModel
    public let geofence: GeofenceModel
    
    // MARK: - Init

    init(id: Int, violationType: ViolationType, fenceId: Int, time: Int, coordinate: CoordinateModel, geofence: GeofenceModel) {
        
        self.id = id
        self.violationType = violationType
        self.fenceId = fenceId
        self.time = time
        self.coordinate = coordinate
        self.geofence = geofence
    }
}
