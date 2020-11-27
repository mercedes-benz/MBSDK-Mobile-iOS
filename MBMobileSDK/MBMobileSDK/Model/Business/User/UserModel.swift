//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBRealmKit

// swiftlint:disable vertical_parameter_alignment

/// Representation of user
public struct UserModel: Entity {
    
    public var id: String {
        return self.ciamId
    }

	public let address: UserAddressModel
	public let birthday: Date?
	public let ciamId: String
	public let createdAt: String
	public let email: String?
	public let firstName: String
	public let lastName1: String
    public let lastName2: String
    public let namePrefix: String?
	public let landlinePhone: String?
	public let mobilePhoneNumber: String?
	public let updatedAt: String
    public let accountCountryCode: String
    public let userPinStatus: UserPinStatus
	public let communicationPreference: UserCommunicationPreferenceModel
	public var profileImageData: Data?
    public var profileImageEtag: String?
	public var unitPreferences: UserUnitPreferenceModel
	public let preferredLanguageCode: String
    public var salutation: String?
    public var title: String?
    public var taxNumber: String?
    public var middleInitial: String?
    public var accountIdentifier: String?
    public var adaptionValues: UserAdaptionValuesModel?
	public var accountVerified: Bool?
    public var isEmailVerified: Bool
    public var isMobileVerified: Bool
    public var toasConsents: [ToasConsentsModel]?
    
    // MARK: - Public Init
    
	public init(
		address: UserAddressModel,
		birthday: Date?,
		ciamId: String,
		createdAt: String,
		email: String?,
		firstName: String,
		lastName1: String,
		lastName2: String,
		landlinePhone: String?,
		mobilePhoneNumber: String?,
		updatedAt: String,
		accountCountryCode: String,
		userPinStatus: UserPinStatus,
		communicationPreference: UserCommunicationPreferenceModel,
		profileImageData: Data?,
        profileImageEtag: String?,
		unitPreferences: UserUnitPreferenceModel,
		salutation: String?,
		title: String?,
		taxNumber: String?,
		namePrefix: String?,
		preferredLanguageCode: String,
		middleInitial: String?,
		accountIdentifier: String?,
		adaptionValues: UserAdaptionValuesModel?,
		accountVerified: Bool?,
        isEmailVerified: Bool,
        isMobileVerified: Bool) {

        self.address = address
		self.birthday = birthday
        self.ciamId = ciamId
        self.createdAt = createdAt
        self.email = email
        self.firstName = firstName
        self.lastName1 = lastName1
        self.lastName2 = lastName2
        self.landlinePhone = landlinePhone
        self.mobilePhoneNumber = mobilePhoneNumber
        self.updatedAt = updatedAt
        self.accountCountryCode = accountCountryCode
        self.userPinStatus = userPinStatus
		self.communicationPreference = communicationPreference
		self.profileImageData = profileImageData
        self.profileImageEtag = profileImageEtag
		self.unitPreferences = unitPreferences
        self.preferredLanguageCode = preferredLanguageCode
        self.salutation = salutation
        self.title = title
        self.taxNumber = taxNumber
        self.namePrefix = namePrefix
        self.middleInitial = middleInitial
        self.accountIdentifier = accountIdentifier
        self.adaptionValues = adaptionValues
		self.accountVerified = accountVerified
        self.isEmailVerified = isEmailVerified
        self.isMobileVerified = isMobileVerified
    }
}


// MARK: - Extension

extension UserModel {
	
	/// Full user name based on PersonNameComponentsFormatter
	public var name: String {
		
		var components = PersonNameComponents()
		components.familyName = self.lastName1
		components.givenName = self.firstName
		components.middleName = self.lastName2
		components.namePrefix = self.namePrefix
		return PersonNameComponentsFormatter().string(from: components)
	}
	/// Logic abstraction to display the correct phone number (mobile number preferred over landline number)
	public var phoneNumber: String {
        return self.mobilePhoneNumber ?? self.landlinePhone ?? ""
	}
    
    public var authenticationIdentifier: String? {
        return self.isEmailVerified ? self.email :
               self.isMobileVerified ? self.mobilePhoneNumber :
               nil
    }
}


extension UserModel: Equatable {

	public static func == (lhs: UserModel, rhs: UserModel) -> Bool {
		return lhs.accountCountryCode == rhs.accountCountryCode &&
			lhs.accountIdentifier == rhs.accountIdentifier &&
			lhs.accountVerified == rhs.accountVerified &&
			lhs.adaptionValues == rhs.adaptionValues &&
			lhs.address == rhs.address &&
			lhs.birthday == rhs.birthday &&
			lhs.ciamId == rhs.ciamId &&
			lhs.communicationPreference == rhs.communicationPreference &&
			lhs.createdAt == rhs.createdAt &&
			lhs.email == rhs.email &&
			lhs.firstName == rhs.firstName &&
			lhs.lastName1 == rhs.lastName1 &&
			lhs.lastName2 == rhs.lastName2 &&
			lhs.landlinePhone == rhs.landlinePhone &&
			lhs.middleInitial == rhs.middleInitial &&
			lhs.mobilePhoneNumber == rhs.mobilePhoneNumber &&
			lhs.namePrefix == rhs.namePrefix &&
			lhs.preferredLanguageCode == rhs.preferredLanguageCode &&
			lhs.profileImageData == rhs.profileImageData &&
            lhs.profileImageEtag == rhs.profileImageEtag &&
			lhs.salutation == rhs.salutation &&
			lhs.taxNumber == rhs.taxNumber &&
			lhs.title == rhs.title &&
			lhs.unitPreferences == rhs.unitPreferences &&
			lhs.updatedAt == rhs.updatedAt &&
			lhs.userPinStatus.rawValue == rhs.userPinStatus.rawValue
	}
}
