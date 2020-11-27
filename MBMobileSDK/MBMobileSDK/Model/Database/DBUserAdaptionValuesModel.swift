//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

/// Database class of user data object
@objcMembers class DBUserAdaptionValuesModel: Object {
    
    let bodyHeight = RealmOptional<Int>()
    let preAdjustment = RealmOptional<Bool>()
    dynamic var alias: String?

    let user = LinkingObjects(fromType: DBUserModel.self, property: "adaptionValues")
    
	override required init() {
        super.init()
    }
    
    init(bodyHeight: Int?, preAdjustment: Bool?, alias: String?) {
        
        self.bodyHeight.value = bodyHeight
        self.preAdjustment.value = preAdjustment
        self.alias = alias
        
        super.init()
    }
}
