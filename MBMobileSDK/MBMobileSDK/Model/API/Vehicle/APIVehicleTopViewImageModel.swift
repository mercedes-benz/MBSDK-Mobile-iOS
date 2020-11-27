//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIVehicleTopViewImageModel: Decodable {
    let vin: String
    let components: [APIVehicleTopViewImageComponentModel]
}
