//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIVehicleVinImageModel: Decodable {
	
	let vinOrFin: String
	let images: [APIVehicleImageModel]
}
