//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIDealerSearchRequestModel: Encodable {

    let zipCodeOrCityName: String?
    let countryIsoCode: String?
    let searchArea: APIDealerSearchSearchAreaRequestModel?
    let brandCode: String?
    let productGroup: String?
    let activity: String?
}
