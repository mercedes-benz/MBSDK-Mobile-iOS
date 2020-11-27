//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//


import RealmSwift

@objcMembers class DBVehicleSpeedAlertModel: Object {
    
    dynamic var endTime: Int64 = 0
    dynamic var threshold: Int64 = 0
    dynamic var thresholdDisplayValue: String = ""
}
