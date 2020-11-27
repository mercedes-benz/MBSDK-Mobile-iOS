//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIVehicleDealerItemModel: Codable {
	
	let dealerId: String
	let role: DealerRole
	let updatedAt: String?
	let dealerData: APIDealerMerchantModel?
}
