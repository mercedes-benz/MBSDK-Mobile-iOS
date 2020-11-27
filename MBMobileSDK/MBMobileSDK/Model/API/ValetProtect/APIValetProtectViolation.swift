//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

struct APIValetProtectViolation: Codable {
    let id: Int
    let violationtype: String
    let time: Int
    let coordinate: APIValetProtectCenter?
    let valetProtect: APIValetProtect
    
    enum CodingKeys: String, CodingKey {
        case id
        case violationtype
        case time
        case coordinate
        case valetProtect = "snapshot"
    }
    
    enum CoordinateKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.violationtype = try values.decode(String.self, forKey: .violationtype)
        self.time = try values.decode(Int.self, forKey: .time)
        self.valetProtect = try values.decode(APIValetProtect.self, forKey: .valetProtect)
        
        guard values.contains(.coordinate) else {
            self.coordinate = nil
            return
        }
        let centerValues = try values.nestedContainer(keyedBy: CoordinateKeys.self, forKey: .coordinate)
        if let latitude = try centerValues.decodeIfPresent(Double.self, forKey: .latitude),
            let longitude = try centerValues.decodeIfPresent(Double.self, forKey: .longitude) {
            self.coordinate =  APIValetProtectCenter(latitude: latitude, longitude: longitude)
        } else {
            self.coordinate = nil
        }
    }
}
