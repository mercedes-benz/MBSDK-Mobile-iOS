//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

@objcMembers class DBDealerOpeningDayModel: Object {

    dynamic var status: String = ""
	
	let periods = List<DBDealerDayPeriodModel>()
}
