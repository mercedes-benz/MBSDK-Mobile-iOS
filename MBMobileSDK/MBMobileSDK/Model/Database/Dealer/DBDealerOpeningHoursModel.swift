//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

@objcMembers class DBDealerOpeningHoursModel: Object {

    dynamic var monday: DBDealerOpeningDayModel?
    dynamic var tuesday: DBDealerOpeningDayModel?
    dynamic var wednesday: DBDealerOpeningDayModel?
	dynamic var thursday: DBDealerOpeningDayModel?
    dynamic var friday: DBDealerOpeningDayModel?
    dynamic var saturday: DBDealerOpeningDayModel?
    dynamic var sunday: DBDealerOpeningDayModel?
}
