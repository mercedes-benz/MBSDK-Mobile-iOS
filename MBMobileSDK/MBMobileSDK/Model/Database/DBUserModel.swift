//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift

/// Database class of user data object
@objcMembers public class DBUserModel: Object {
	
	dynamic var ciamId: String = ""
	dynamic var firstName: String = ""
	dynamic var lastName1: String = ""
	dynamic var lastName2: String?
	dynamic var title: String?
	dynamic var namePrefix: String?
	dynamic var middleInitial: String?
	dynamic var salutationCode: String?
	dynamic var email: String?
	dynamic var landlinePhone: String?
	dynamic var mobilePhoneNumber: String?
	dynamic var birthday: String?
	dynamic var preferredLanguageCode: String?
	dynamic var accountCountryCode: String?
	dynamic var createdAt: String = ""
	dynamic var updatedAt: String = ""
	dynamic var address: DBUserAddressModel?
	dynamic var communicationPreference: DBUserCommunicationPreferenceModel?
	dynamic var userPinStatus: String?
	dynamic var profileImageData: Data?
    dynamic var profileImageEtag: String?
	dynamic var unitPreference: DBUserUnitPreferenceModel?
    dynamic var taxNumber: String?
	dynamic var adaptionValues: DBUserAdaptionValuesModel?
    dynamic var isEmailVerified: Bool = false
    dynamic var isMobileVerified: Bool = false
	
	let accountVerified = RealmOptional<Bool>()
	
	
	// MARK: - Realm
	
	override public static func primaryKey() -> String? {
		return "ciamId"
	}
    
	override required init() {
        super.init()
    }
    
    init(
		ciamId: String,
		firstName: String,
		lastName1: String,
		lastName2: String?,
		title: String?,
		namePrefix: String?,
		middleInitial: String?,
		salutationCode: String?,
		email: String?,
		landlinePhone: String?,
		mobilePhoneNumber: String?,
		birthday: String?,
		preferredLanguageCode: String?,
		accountCountryCode: String?,
		createdAt: String,
		updatedAt: String,
		address: DBUserAddressModel?,
		communicationPreference: DBUserCommunicationPreferenceModel?,
		userPinStatus: String?,
		profileImageData: Data?,
		profileImageEtag: String?,
		unitPreference: DBUserUnitPreferenceModel?,
		taxNumber: String?,
		adaptionValues: DBUserAdaptionValuesModel?,
		accountVerified: Bool?,
		isEmailVerified: Bool,
		isMobileVerified: Bool) {
        
        self.ciamId = ciamId
        self.firstName = firstName
        self.lastName1 = lastName1
        self.lastName2 = lastName2
        self.title = title
        self.namePrefix = namePrefix
        self.middleInitial = middleInitial
        self.salutationCode = salutationCode
        self.email = email
        self.landlinePhone = landlinePhone
        self.mobilePhoneNumber = mobilePhoneNumber
        self.birthday = birthday
        self.preferredLanguageCode = preferredLanguageCode
        self.accountCountryCode = accountCountryCode
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.address = address
        self.communicationPreference = communicationPreference
        self.userPinStatus = userPinStatus
        self.profileImageData = profileImageData
        self.profileImageEtag = profileImageEtag
        self.unitPreference = unitPreference
        self.taxNumber = taxNumber
        self.adaptionValues = adaptionValues
		self.accountVerified.value = accountVerified
        self.isEmailVerified = isEmailVerified
        self.isMobileVerified = isMobileVerified
        
        super.init()
    }
}
