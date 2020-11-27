//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIVehicleServiceActivationModel: Encodable {

    let desiredServiceStatus: ServiceActivationStatus
    let serviceId: Int
}
