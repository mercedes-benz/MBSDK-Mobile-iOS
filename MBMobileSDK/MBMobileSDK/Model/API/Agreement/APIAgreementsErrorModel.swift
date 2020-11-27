//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

struct APIAgreementsErrorModel: Decodable {
    let error: String
    let subsystem: String
	
	enum CodingKeys: String, CodingKey {
		case error = "Error"
		case subsystem = "Subsystem"
	}
}
