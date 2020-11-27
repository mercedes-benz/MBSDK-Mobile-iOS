//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public class APIGeofence: Decodable {
    let id: Int
    let isActive: Bool
    let name: String
    let activeTimes: APIActiveTimes
    let violationType: String
    let shape: APIShape
    
    
    enum CodingKeys: String, CodingKey {
        case id, isActive
        case name
        case activeTimes, violationType, shape
    }
    
    enum ShapeKeys: String, CodingKey {
        case circle
        case polygon
        case radius
        case center
        case coordinates
    }
    
    required public init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
		self.name = try values.decode(String.self, forKey: .name)
        self.activeTimes = try values.decode(APIActiveTimes.self, forKey: .activeTimes)
        self.violationType = try values.decode(String.self, forKey: .violationType)
        self.isActive = try values.decode(Bool.self, forKey: .isActive)
        self.id = try values.decode(Int.self, forKey: .id)
        
        let shapeInfo = try values.nestedContainer(keyedBy: ShapeKeys.self, forKey: .shape)
        var shapeInfoValues: KeyedDecodingContainer<ShapeKeys>
        if shapeInfo.contains(.circle) {
            
            shapeInfoValues = try shapeInfo.nestedContainer(keyedBy: ShapeKeys.self, forKey: .circle)
            let radius = try shapeInfoValues.decodeIfPresent(Double.self, forKey: .radius)
            let center = try shapeInfoValues.decodeIfPresent(APICoordinateModel.self, forKey: .center)
            self.shape = APIShape(center: center, radius: radius, coordinates: nil)
        } else if shapeInfo.contains(.polygon) {
            
            shapeInfoValues = try shapeInfo.nestedContainer(keyedBy: ShapeKeys.self, forKey: .polygon)
            let coordinates = shapeInfoValues.decodeArraySafelyIfPresent(APICoordinateModel.self, forKey: .coordinates)
            self.shape = APIShape(center: nil, radius: nil, coordinates: coordinates)
        } else {
            self.shape = APIShape(center: nil, radius: nil, coordinates: nil)
        }
    }
}
