//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIDealerOpeningHoursModel: Codable {

    let monday: APIDealerOpeningDayModel?
    let tuesday: APIDealerOpeningDayModel?
    let wednesday: APIDealerOpeningDayModel?
    let thursday: APIDealerOpeningDayModel?
    let friday: APIDealerOpeningDayModel?
    let saturday: APIDealerOpeningDayModel?
    let sunday: APIDealerOpeningDayModel?

	enum CodingKeys: String, CodingKey {
		case monday = "MONDAY"
		case tuesday = "TUESDAY"
		case wednesday = "WEDNESDAY"
		case thursday = "THURSDAY"
		case friday = "FRIDAY"
		case saturday = "SATURDAY"
		case sunday = "SUNDAY"
	}
}
