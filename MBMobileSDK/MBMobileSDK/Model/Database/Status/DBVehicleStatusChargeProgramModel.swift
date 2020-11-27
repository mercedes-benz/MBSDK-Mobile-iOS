//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import RealmSwift

@objcMembers class DBVehicleStatusChargeProgramModel: Object {
    
    dynamic var displayValue: String = ""
    dynamic var status: Int32 = 0
    dynamic var timestamp: Int64 = 0
    let values = List<DBVehicleChargeProgramModel>()
}
