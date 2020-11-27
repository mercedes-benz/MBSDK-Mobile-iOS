//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIDealerOpeningDayModel: Codable {

    let status: APIDealerOpeningStatus?
    let periods: [APIDealerDayPeriodModel]

	// MARK: - Init

	init(from decoder: Decoder) throws {

		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.status  = try container.decode(APIDealerOpeningStatus.self, forKey: .status)
		self.periods = container.decodeArraySafelyIfPresent(APIDealerDayPeriodModel.self, forKey: .periods) ?? []
	}
}

enum APIDealerOpeningStatus: String, Codable {
	case closed = "CLOSED"
	case open = "OPEN"
}
