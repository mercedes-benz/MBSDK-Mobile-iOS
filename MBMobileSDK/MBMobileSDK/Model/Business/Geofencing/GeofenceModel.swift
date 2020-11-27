//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of geofence
public struct GeofenceModel: Encodable {
    
    public let id: Int?
    public var isActive: Bool
    public var name: String?
    public var activeTimes: ActiveTimesModel
    public var violationType: ViolationType
    public var shape: ShapeModel
    
    // MARK: - Init

    public init(id: Int? = nil, isActive: Bool, name: String? = nil, activeTimes: ActiveTimesModel, violationType: ViolationType, shape: ShapeModel) {
        
        self.id = id
        self.isActive = isActive
        self.name = name
        self.activeTimes = activeTimes
        self.violationType = violationType
        self.shape = shape
    }
    
    enum CodingKeys: String, CodingKey {
        case id, isActive
        case name
        case activeTimes, violationType, shape
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(activeTimes, forKey: .activeTimes)
        try container.encode(violationType, forKey: .violationType)
        try container.encode(isActive, forKey: .isActive)
        try container.encodeIfPresent(id, forKey: .id)
    }
    
    // MARK: - Params

    public func params() -> [String: Any]? {
        
        let json = try? self.toJson()
        var bodyDict = json as? [String: Any]
        
        let jsonShape = try? self.shape.toJson()
        var shapeDict = jsonShape as? [String: Any]
        shapeDict = shapeDict?.compactMapValues({ $0 })
        
        if self.shape.center != nil && self.shape.radius != nil {
            
            bodyDict?["shape"] = ["circle": shapeDict]
        } else if self.shape.coordinates != nil {
            bodyDict?["shape"] = ["polygon": shapeDict]
        }
        
        return bodyDict
    }
    
}
