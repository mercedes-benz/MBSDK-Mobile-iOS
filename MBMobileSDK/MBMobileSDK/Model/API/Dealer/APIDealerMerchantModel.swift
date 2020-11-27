//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIDealerMerchantModel: Codable {

    let legalName: String?
    var address: APIDealerAddressModel?
    var openingHours: APIDealerOpeningHoursModel?
}
