//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIVehicleImageModel: Decodable {
	
	let error: APIErrorMessageModel?
	let imageKey: String
	let url: String?
}
