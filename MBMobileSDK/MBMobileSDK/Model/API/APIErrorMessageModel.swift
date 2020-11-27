//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIErrorMessageModel: Decodable {
	
	let code: Int?
	let message: String?
}
