//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIUserModel: Codable {
	
	let ciamId: String
	let firstName: String?
	let lastName1: String?
	let lastName2: String?
	let title: String?
	let namePrefix: String?
	let middleInitial: String?
	let salutationCode: String?
	let email: String?
	let landlinePhone: String?
	let mobilePhoneNumber: String?
	let birthday: String?
	let preferredLanguageCode: String?
	let accountCountryCode: String?
	let createdAt: String
	let createdBy: String?
	let updatedAt: String
	let address: APIUserAddressModel?
	let communicationPreference: APIUserCommunicationPreferenceModel?
	let userPinStatus: String?
	let unitPreferences: APIUserUnitPreferenceModel
    let taxNumber: String?
    let accountIdentifier: String?
    let useEmailAsUsername: Bool?
    let adaptionValues: APIUserAdaptionValuesModel?
	let accountVerified: Bool?
    let isEmailVerified: Bool?
    let isMobileVerified: Bool?
    let toasConsents: [ToasConsentsModel]?
    let nonce: String?
}
