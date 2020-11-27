//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIVehicleAssignedUserModel: Decodable {

	let authorizationId: String?
	let displayName: String?
	let email: String?
	let mobileNumber: String?
	let profilePictureLink: String?
    let validUntil: String?
}
