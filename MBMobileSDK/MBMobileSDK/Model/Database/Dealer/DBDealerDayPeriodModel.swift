//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

@objcMembers class DBDealerDayPeriodModel: Object {

    dynamic var from: String = ""
    dynamic var until: String = ""
	
	let periods = LinkingObjects(fromType: DBDealerOpeningDayModel.self, property: "periods")
}
