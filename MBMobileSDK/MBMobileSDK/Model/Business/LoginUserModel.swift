//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct LoginUserModel: Encodable {
	
	let countryCode: String
	let emailOrPhoneNumber: String
	let locale: String
    let nonce: String
}
