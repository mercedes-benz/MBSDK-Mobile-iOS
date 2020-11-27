//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIDealerAddressModel: Codable {

    let street: String?
    let addressAddition: String?
    let zipCode: String?
    let city: String?
    let district: String?
    let countryIsoCode: String?
}
