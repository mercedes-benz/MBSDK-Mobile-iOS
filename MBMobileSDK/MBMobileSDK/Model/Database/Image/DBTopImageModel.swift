//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class DBTopImageModel: Object {
    
    // MARK: Properties
    dynamic var vin: String = ""
    var components = List<DBTopImageComponentModel>()
    
    // MARK: - Realm
    override public static func primaryKey() -> String? {
        return "vin"
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        
        guard let rhs = object as? DBTopImageModel else {
            return false
        }
        
        let compareComponents = zip(self.components, rhs.components).compactMap {
            return $0.0.isEqual($0.1) ? nil : true
        }
        
        return self.vin == rhs.vin &&
            (compareComponents.isEmpty && self.components.count == rhs.components.count)
    }
}


@objcMembers class DBTopImageComponentModel: Object {
    
    // MARK: Properties
    dynamic var name: String = ""
    dynamic var imageData: Data?
    
    // MARK: - Realm
    override public static func primaryKey() -> String? {
        return "name"
    }
}
