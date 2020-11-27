//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of speed alert violation coordinate
public struct SpeedAlertCoordinatesModel {
    public let heading: Double?
    public let latitude: Double?
    public let longitude: Double?
    
	
    // MARK: - Init
    
    public init(latitude: Double?, longitude: Double?, heading: Double?) {
        
        self.heading = heading
        self.latitude = latitude
        self.longitude = longitude
    }
}
