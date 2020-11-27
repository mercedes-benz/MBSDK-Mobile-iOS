//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIDealerSearchAddressModel: Decodable {
	
	let street: String?
	let zipCode: String?
	let city: String?
	let countryIsoCode: String?
}
