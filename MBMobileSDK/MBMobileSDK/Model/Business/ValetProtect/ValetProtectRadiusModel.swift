//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of radius data
public struct ValetProtectRadiusModel: Encodable {
    
    public let value: Float
    public let unit: DistanceUnit
    
    // MARK: - Init
    
    public init(value: Float, unit: DistanceUnit) {
        
        self.value = value
        self.unit = unit
    }
    
    enum CodingKeys: String, CodingKey {
        case value
        case unit
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
        try container.encode(unit.mapToString(), forKey: .unit)
    }
}
