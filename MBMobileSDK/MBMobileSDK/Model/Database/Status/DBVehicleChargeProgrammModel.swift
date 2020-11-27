//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import RealmSwift

@objcMembers class DBVehicleChargeProgramModel: Object {
    
    dynamic var autoUnlock: Bool = false
    dynamic var chargeProgram: Int64 = 0
    dynamic var clockTimer: Bool = false
    dynamic var ecoCharging: Bool = false
    dynamic var locationBasedCharging: Bool = false
    dynamic var maxChargingCurrent: Int64 = 0
    dynamic var maxSoc: Int64 = 0
    dynamic var weeklyProfile: Bool = false
}
