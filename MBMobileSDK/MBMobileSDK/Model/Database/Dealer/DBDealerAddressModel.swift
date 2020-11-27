//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

@objcMembers class DBDealerAddressModel: Object {

    dynamic var street: String = ""
    dynamic var addressAddition: String = ""
    dynamic var zipCode: String = ""
    dynamic var city: String = ""
    dynamic var district: String = ""
    dynamic var countryIsoCode: String = ""
}
