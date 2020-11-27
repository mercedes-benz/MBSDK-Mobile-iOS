//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

@objcMembers public class DBSendToCarCapabilitiesModel: Object {

    // MARK: Properties
    dynamic var finOrVin: String = ""
	dynamic var capabilities: String = ""
	dynamic var preconditions: String = ""


    // MARK: - Realm
    
    override public static func primaryKey() -> String? {
        return "finOrVin"
    }
}
