//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//
import Foundation

public class UserProfileModel {
    
    public var city: String?
    public var countryCode: String?
    public var houseNo: String?
    public var doorNo: String?
    public var state: String?
    public var street: String?
    public var province: String?
    public var zipCode: String?
    public var birthday: Date?
    public var ciamId: String?
    public var createdAt: String?
    public var email: String?
    public var firstName: String?
    public var lastName1: String?
    public var lastName2: String?
    public var landlinePhone: String?
    public var mobilePhoneNumber: String?
    public var updatedAt: String?
    public var accountCountryCode: String?
    public var userPinStatus: UserPinStatus?
    public var profileImageData: Data?
    public var profileImageEtag: String?
    public var unitPreferences: UserUnitPreferenceModel?
    public var salutation: String?
    public var title: String?
    public var communicationPhone: Bool?
    public var communicationLetter: Bool?
    public var communicationEmail: Bool?
    public var communicationSms: Bool?
    public var accountIdentifier: UserAccountIdentifier?
    public var addressLine1: String?
    public var streetType: String?
    public var houseName: String?
    public var floorNo: String?
    public var addressLine2: String?
    public var addressLine3: String?
    public var postOfficeBox: String?
    public var taxNumber: String?
    public var namePrefix: String?
    public var preferredLanguageCode: String?
    public var middleInitial: String?
    public var bodyHeight: Int?
    public var preAdjustment: Bool = false
    public var alias: String?
    public var accountVerified: Bool?
    public var isEmailVerified: Bool?
    public var isMobileVerified: Bool?
    
    // MARK: - Public Init
    
    public init(userModel: UserModel) {
        self.city = userModel.address.city
        self.countryCode = userModel.address.countryCode
        self.houseNo = userModel.address.houseNo
        self.state = userModel.address.state
        self.street = userModel.address.street
        self.zipCode = userModel.address.zipCode
        self.birthday = userModel.birthday
        self.ciamId = userModel.ciamId
        self.createdAt = userModel.createdAt
        self.email = userModel.email
        self.firstName = userModel.firstName
        self.lastName1 = userModel.lastName1
        self.lastName2 = userModel.lastName2
        self.landlinePhone = userModel.landlinePhone
        self.mobilePhoneNumber = userModel.mobilePhoneNumber
        self.updatedAt = userModel.updatedAt
        self.accountCountryCode = userModel.accountCountryCode
        self.userPinStatus = userModel.userPinStatus
        self.communicationPhone = userModel.communicationPreference.phone
        self.communicationLetter = userModel.communicationPreference.letter
        self.communicationEmail = userModel.communicationPreference.email
        self.communicationSms = userModel.communicationPreference.sms
        self.profileImageData = userModel.profileImageData
        self.profileImageEtag = userModel.profileImageEtag
        self.unitPreferences = userModel.unitPreferences
        self.salutation = userModel.salutation
        self.title = userModel.title
        self.province = userModel.address.province
        self.doorNo = userModel.address.doorNo
        self.addressLine1 = userModel.address.addressLine1
        self.addressLine2 = userModel.address.addressLine2
        self.addressLine3 = userModel.address.addressLine3
        self.taxNumber = userModel.taxNumber
        self.preferredLanguageCode = userModel.preferredLanguageCode
        self.middleInitial = userModel.middleInitial
        self.bodyHeight = userModel.adaptionValues?.bodyHeight
        self.preAdjustment = userModel.adaptionValues?.preAdjustment ?? false
        self.alias = userModel.adaptionValues?.alias
        self.streetType = userModel.address.streetType
        self.accountVerified = userModel.accountVerified
        self.houseName = userModel.address.houseName
        self.floorNo = userModel.address.floorNo
        self.postOfficeBox = userModel.address.postOfficeBox
        self.namePrefix = userModel.namePrefix
        self.isMobileVerified = userModel.isMobileVerified
        self.isEmailVerified = userModel.isEmailVerified
    }
    
    public init () {}
}

extension UserProfileModel {
	
    public func toUserModel() -> UserModel {
		
		let address = UserAddressModel(city: self.city,
									   countryCode: self.countryCode,
									   houseNo: self.houseNo,
									   state: self.state,
									   street: self.street,
									   zipCode: self.zipCode,
									   province: self.province,
									   doorNo: self.doorNo,
									   addressLine1: self.addressLine1,
									   streetType: self.streetType,
									   houseName: self.houseName,
									   floorNo: self.floorNo,
									   addressLine2: self.addressLine2,
									   addressLine3: self.addressLine3,
									   postOfficeBox: self.postOfficeBox)
        let communicationPreference = UserCommunicationPreferenceModel(phone: self.communicationPhone,
                                                                       letter: self.communicationLetter,
                                                                       email: self.communicationEmail,
                                                                       sms: self.communicationSms)
        let adaptionValues = UserAdaptionValuesModel(bodyHeight: self.bodyHeight,
                                                     preAdjustment: self.preAdjustment,
                                                     alias: self.alias)
        
        return UserModel(address: address,
                         birthday: self.birthday,
                         ciamId: self.ciamId ?? "",
                         createdAt: self.createdAt ?? "",
                         email: self.email,
                         firstName: self.firstName ?? "",
                         lastName1: self.lastName1 ?? "",
                         lastName2: self.lastName2 ?? "",
                         landlinePhone: self.landlinePhone,
                         mobilePhoneNumber: self.mobilePhoneNumber,
                         updatedAt: self.updatedAt ?? "",
                         accountCountryCode: self.accountCountryCode ?? "",
                         userPinStatus: self.userPinStatus ?? UserPinStatus.notSet,
                         communicationPreference: communicationPreference,
                         profileImageData: self.profileImageData,
                         profileImageEtag: self.profileImageEtag,
                         unitPreferences: self.unitPreferences ?? UserUnitPreferenceModel(),
                         salutation: self.salutation,
                         title: self.title,
                         taxNumber: self.taxNumber,
                         namePrefix: self.namePrefix,
                         preferredLanguageCode: self.preferredLanguageCode ?? "",
                         middleInitial: self.middleInitial,
                         accountIdentifier: self.accountIdentifier?.rawValue,
						 adaptionValues: adaptionValues,
                         accountVerified: self.accountVerified ?? false,
                         isEmailVerified: self.isEmailVerified ?? false,
                         isMobileVerified: self.isMobileVerified ?? false)
    }
}
