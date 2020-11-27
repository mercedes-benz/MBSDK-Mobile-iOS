//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIUserAddressModel: Codable {
	
	let countryCode: String?
	let state: String?
	let province: String?
	let street: String?
	let houseNo: String?
	let zipCode: String?
	let city: String?
	let streetType: String?
	let houseName: String?
	let floorNo: String?
	let doorNo: String?
	let addressLine1: String?
	let addressLine2: String?
	let addressLine3: String?
	let postOfficeBox: String?
}
