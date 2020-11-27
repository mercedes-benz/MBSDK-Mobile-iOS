//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIDealerSearchCoordinateRequestModel: Codable {

    let latitude: String
    let longitude: String
}

struct APIDealerSearchCoordinateModel: Codable {

    let latitude: Double
    let longitude: Double
}
