//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIRegistrationUserModel: Codable {
	
	let countryCode: String
	let email: String
	let firstName: String
	let id: String
	let lastName: String
	let mobileNumber: String
	let useEmailAsUsername: Bool
	let username: String
	let communicationPreference: APIUserCommunicationPreferenceModel?
}
