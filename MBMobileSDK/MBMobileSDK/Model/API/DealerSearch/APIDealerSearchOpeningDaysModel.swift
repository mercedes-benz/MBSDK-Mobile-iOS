//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIDealerSearchOpeningDaysModel: Decodable {
	
	let monday: APIDealerSearchOpeningModel?
	let tuesday: APIDealerSearchOpeningModel?
	let wednesday: APIDealerSearchOpeningModel?
	let thursday: APIDealerSearchOpeningModel?
	let friday: APIDealerSearchOpeningModel?
	let saturday: APIDealerSearchOpeningModel?
	let sunday: APIDealerSearchOpeningModel?
	
	
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
