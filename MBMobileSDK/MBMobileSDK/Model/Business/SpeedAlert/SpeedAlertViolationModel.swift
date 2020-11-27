//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of speed alert violation
public struct SpeedAlertViolationModel {
    
    public let id: Int
    public let time: Int
    public let speedalertTreshold: Int
    public let speedalertEndtime: Int
    public let coordinates: SpeedAlertCoordinatesModel
    
    // MARK: - Init
    
    public init(id: Int, time: Int, speedalertTreshold: Int, speedalertEndtime: Int, coordinates: SpeedAlertCoordinatesModel) {
        
        self.id =  id
        self.time = time
        self.speedalertTreshold = speedalertTreshold
        self.speedalertEndtime = speedalertEndtime
        self.coordinates = coordinates
    }
}
