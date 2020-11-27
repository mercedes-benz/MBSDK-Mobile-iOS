//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIVehicleServiceGroupModel: Decodable {
	
	let group: String
	let services: [APIVehicleServiceModel]
}
