//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import XCTest
@testable import MBMobileSDK

class UserModelTest: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	
	// MARK: - Tests
	
	func testUserModelName() {
		
		let firstName = "TestA"
		let lastName  = "TestB"
		let name      = firstName + " " + lastName
		let userModel = UserModel.create(firstName: firstName, lastName1: lastName)
		
		XCTAssertTrue(userModel.name == name)
	}
	
	func testUserModelPhoneNumber() {
		
		let landline = "0123456"
		let mobile   = "567890"
		
		let landlineUserModel = UserModel.create(landlinePhone: landline)
		let mobileUserModel   = UserModel.create(mobilePhoneNumber: mobile)
		let numberUserModel   = UserModel.create(landlinePhone: landline, mobilePhoneNumber: mobile)

		XCTAssertTrue(landlineUserModel.phoneNumber == landline)
		XCTAssertTrue(mobileUserModel.phoneNumber == mobile)
		XCTAssertTrue(numberUserModel.phoneNumber == mobile)
	}
}


// MARK: - RegistrationUserModel

extension UserAddressModel {
	
	static func create(
		city: String = "",
		countryCode: String = "",
		houseNo: String = "",
		state: String = "",
		street: String = "",
		zipCode: String = "",
		province: String = "",
		doorNo: String = "",
		addressLine1: String = "",
		streetType: String = "",
		houseName: String = "",
		floorNo: String = "",
		addressLine2: String = "",
		addressLine3: String = "",
		postOfficeBox: String = "") -> UserAddressModel {
		return UserAddressModel(city: city,
								countryCode: countryCode,
								houseNo: houseNo,
								state: state,
								street: street,
								zipCode: zipCode,
								province: province,
								doorNo: doorNo,
								addressLine1: addressLine1,
								streetType: streetType,
								houseName: houseName,
								floorNo: floorNo,
								addressLine2: addressLine2,
								addressLine3: addressLine3,
								postOfficeBox: postOfficeBox)
	}
}

extension UserModel {
	
	static func create(
		address: UserAddressModel = UserAddressModel.create(),
		birthday: Date? = nil,
		ciamId: String = "",
		createdAt: String = "",
		email: String = "",
		firstName: String = "",
		lastName1: String = "",
		lastName2: String = "",
		landlinePhone: String? = nil,
		mobilePhoneNumber: String? = nil,
		updatedAt: String = "",
        accountCountryCode: String = "",
		communicationPreference: UserCommunicationPreferenceModel = UserCommunicationPreferenceModel.create(),
        profileImageData: Data? = nil,
        profileImageEtag: String? = nil,
		unitPreferences: UserUnitPreferenceModel = UserUnitPreferenceModel.create(),
        adaptionValues: UserAdaptionValuesModel = UserAdaptionValuesModel(bodyHeight: nil, preAdjustment: nil, alias: nil),
		preferredLanguageCode: String = "") -> UserModel {
		return UserModel(address: address,
						 birthday: birthday,
						 ciamId: ciamId,
						 createdAt: createdAt,
						 email: email,
						 firstName: firstName,
						 lastName1: lastName1,
						 lastName2: lastName2,
						 landlinePhone: landlinePhone,
						 mobilePhoneNumber: mobilePhoneNumber,
						 updatedAt: updatedAt,
                         accountCountryCode: accountCountryCode,
                         userPinStatus: .unknown,
						 communicationPreference: communicationPreference,
                         profileImageData: profileImageData,
                         profileImageEtag: profileImageEtag,
						 unitPreferences: unitPreferences,
						 salutation: nil,
						 title: nil,
						 taxNumber: nil,
						 namePrefix: nil,
						 preferredLanguageCode: preferredLanguageCode,
						 middleInitial: nil,
                         accountIdentifier: nil,
						 adaptionValues: adaptionValues,
                         accountVerified: false,
                         isEmailVerified: false,
                         isMobileVerified: false)
	}
}

extension UserCommunicationPreferenceModel {
	
	static func create() -> UserCommunicationPreferenceModel {
		return UserCommunicationPreferenceModel(phone: nil,
												letter: nil,
												email: nil,
												sms: nil)
	}
}

extension UserUnitPreferenceModel {
	
	static func create() -> UserUnitPreferenceModel {
		return UserUnitPreferenceModel()
	}
}
