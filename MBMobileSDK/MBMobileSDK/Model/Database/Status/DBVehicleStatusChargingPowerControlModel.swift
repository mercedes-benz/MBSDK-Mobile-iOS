//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import RealmSwift

@objcMembers class DBVehicleStatusChargingPowerControlModel: Object {
    
    dynamic var displayValue: String = ""
    dynamic var status: Int32 = 0
    dynamic var timestamp: Int64 = 0
	
	dynamic var chargingStatus: Int = 0
    dynamic var controlDuration: Int64 = 0
    dynamic var controlInfo: Int = 0
    dynamic var chargingPower: Int = 0
    dynamic var serviceStatus: Int = 0
    dynamic var serviceAvailable: Int = 0
    dynamic var useCase: Int = 0
}
