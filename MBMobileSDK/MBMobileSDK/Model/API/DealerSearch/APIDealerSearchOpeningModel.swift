//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIDealerSearchOpeningModel: Decodable {
	
	enum CodingKeys: String, CodingKey {
		case status
		case periods
	}
	
	let status: OpeningStatus
	let periods: [APIDealerSearchOpeningPeriodModel]
	
	
	// MARK: - Init
	
	init(from decoder: Decoder) throws {

		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		self.status  = try container.decode(OpeningStatus.self, forKey: .status)
		self.periods = container.decodeArraySafelyIfPresent(APIDealerSearchOpeningPeriodModel.self, forKey: .periods) ?? []
	}
}

enum OpeningStatus: String, Codable {
	case closed = "CLOSED"
	case open = "OPEN"
}
