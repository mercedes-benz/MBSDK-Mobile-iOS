//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

@objcMembers class DBDealerMerchantModel: Object {

    dynamic var legalName: String = ""
    dynamic var address: DBDealerAddressModel?
    dynamic var openingHours: DBDealerOpeningHoursModel?
}
