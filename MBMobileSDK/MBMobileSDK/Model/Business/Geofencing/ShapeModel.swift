//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of geofence shape model
public struct ShapeModel: Encodable {
    
    public let center: CoordinateModel?
    public let radius: Double?
    public let coordinates: [CoordinateModel]?
    
    // MARK: - Init

    public init(center: CoordinateModel? = nil, radius: Double? = nil, coordinates: [CoordinateModel]? = nil) {
        self.center = center
        self.radius = radius
        self.coordinates = coordinates
    }
}
