//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIValetProtect: Codable {
    let name: String?
    let violationtypes: [String]
    let center: APIValetProtectCenter?
    let radius: APIValetProtectRadius?
    
    enum CodingKeys: String, CodingKey {
        case name
        case violationtypes
        case center
        case radius
    }
    
    enum CoordinateKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try values.decodeIfPresent(String.self, forKey: .name)
        self.violationtypes = try values.decodeIfPresent([String].self, forKey: .violationtypes) ?? []
        self.radius = try values.decodeIfPresent(APIValetProtectRadius.self, forKey: .radius)
        
        guard values.contains(.center) else {
            self.center = nil
            return
        }

        let centerValues = try values.nestedContainer(keyedBy: CoordinateKeys.self, forKey: .center)
        if let latitude = try centerValues.decodeIfPresent(Double.self, forKey: .latitude),
            let longitude = try centerValues.decodeIfPresent(Double.self, forKey: .longitude) {
            self.center =  APIValetProtectCenter(latitude: latitude, longitude: longitude)
        } else {
            self.center = nil
        }
    }
}
