//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

/// Database class of user data object
@objcMembers class DBUserUnitPreferenceModel: Object {
	
	dynamic var clockHours: String = ""
	dynamic var consumptionCo: String = ""
	dynamic var consumptionEv: String = ""
	dynamic var consumptionGas: String = ""
	dynamic var speedDistance: String = ""
	dynamic var temperature: String = ""
	dynamic var tirePressure: String = ""

	let user = LinkingObjects(fromType: DBUserModel.self, property: "unitPreference")
    
	override required init() {
        super.init()
    }
    
    init(clockHours: String,
         consumptionCo: String,
         consumptionEv: String,
         consumptionGas: String,
         speedDistance: String,
         temperature: String,
         tirePressure: String) {
        
        self.clockHours = clockHours
        self.consumptionCo = consumptionCo
        self.consumptionEv = consumptionEv
        self.consumptionGas = consumptionGas
        self.speedDistance = speedDistance
        self.temperature = temperature
        self.tirePressure = tirePressure
    }
}
