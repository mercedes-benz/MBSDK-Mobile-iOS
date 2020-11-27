//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import RealmSwift

@objcMembers class DBVehicleChargingBreakClockTimerModel: Object {
    
    dynamic var action: Int = 0
    dynamic var endTimeHour: Int = 0
    dynamic var endTimeMin: Int = 0
    dynamic var startTimeHour: Int = 0
    dynamic var startTimeMin: Int = 0
    dynamic var timerId: Int = 0
}
