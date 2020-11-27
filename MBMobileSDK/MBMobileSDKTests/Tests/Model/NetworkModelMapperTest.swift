//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import XCTest
@testable import MBMobileSDK

class NetworkModelMapperTest: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	
	// MARK: - Tests
	
	func testMapLoginModel() {
		
		let apiModel = APILoginModel.create(accessToken: "access",
											expiresIn: 20,
											refreshToken: "refresh",
											tokenType: "tokenType")
		
        let model1 = NetworkModelMapper.map(apiLogin: apiModel, authenticationType: .keycloak)
		
		XCTAssertTrue(model1.accessToken == apiModel.accessToken &&
                      model1.refreshToken == apiModel.refreshToken &&
                      model1.authenticationType == .keycloak)
	}
	
	func testMapRegistrationUserModel() {
		
		let apiModel = APIRegistrationUserModel.create(countryCode: "DE",
													   email: "email",
													   firstName: "firstname",
													   lastName: "lastname",
													   password: "password",
													   username: "username",
													   communicationPreference: nil)
		let model = NetworkModelMapper.map(apiRegistrationUser: apiModel)
		XCTAssertTrue(model.countryCode == apiModel.countryCode &&
			model.email == apiModel.email &&
			model.firstName == apiModel.firstName &&
			model.lastName == apiModel.lastName &&
			model.userName == apiModel.username)
	}
	
	func testMapUserAddressModel() {
		
		let apiAddressModel = APIUserAddressModel.create(countryCode: "DE",
												  state: "Germany",
												  street: "Test street",
												  zipCode: "12345",
												  city: "Test")
		let apiModel = APIUserModel.create(address: apiAddressModel,
										   ciamId: "ciamId",
										   firstName: "firstName",
										   lastName1: "lastName1")
		let userModel = NetworkModelMapper.map(apiUser: apiModel)
		XCTAssertTrue(userModel.ciamId == apiModel.ciamId &&
			userModel.firstName == apiModel.firstName &&
			userModel.lastName1 == apiModel.lastName1 &&
			userModel.address.city == apiAddressModel.city)
	}
	
	func testMapUserModel() {
		
		let apiModel = APIUserModel.create(ciamId: "ciamId",
										   firstName: "firstName",
										   lastName1: "lastName1")
		let userModel = NetworkModelMapper.map(apiUser: apiModel)
		XCTAssertTrue(userModel.ciamId == apiModel.ciamId &&
			userModel.firstName == apiModel.firstName &&
			userModel.lastName1 == apiModel.lastName1)
		
        let newApiModel = NetworkModelMapper.map(user: userModel, nonce: nil)
		XCTAssertTrue(userModel.ciamId == newApiModel.ciamId &&
			userModel.firstName == newApiModel.firstName &&
			userModel.lastName1 == newApiModel.lastName1 &&
            newApiModel.nonce == nil)
	}
    
    func testMapUserModelWithNonce() {
        
        let apiModel = APIUserModel.create(ciamId: "ciamId",
                                           firstName: "firstName",
                                           lastName1: "lastName1")
        let userModel = NetworkModelMapper.map(apiUser: apiModel)
        XCTAssertTrue(userModel.ciamId == apiModel.ciamId &&
            userModel.firstName == apiModel.firstName &&
            userModel.lastName1 == apiModel.lastName1)
        
        let nonce = "XD298765"
        
        let newApiModel = NetworkModelMapper.map(user: userModel, nonce: nonce)
        XCTAssertTrue(userModel.ciamId == newApiModel.ciamId &&
            userModel.firstName == newApiModel.firstName &&
            userModel.lastName1 == newApiModel.lastName1 &&
            newApiModel.nonce == nonce)
    }
}


// MARK: - Extensions

extension APILoginModel {
	
	static func create(
		accessToken: String = "",
		expiresIn: Int = 0,
		refreshToken: String = "",
		tokenType: String = "") -> APILoginModel {
		
		return APILoginModel(accessToken: accessToken,
							 expiresIn: expiresIn,
							 refreshToken: refreshToken,
							 tokenType: tokenType)
	}
}


extension APIRegistrationUserModel {
	
	static func create(
		countryCode: String = "",
		email: String = "",
		firstName: String = "",
		id: String = "",
		lastName: String = "",
		mobileNumber: String = "",
		password: String = "",
		useEmailAsUsername: Bool = true,
		username: String = "",
		communicationPreference: APIUserCommunicationPreferenceModel?) -> APIRegistrationUserModel {
		
		return APIRegistrationUserModel(countryCode: countryCode,
										email: email,
										firstName: firstName,
										id: id,
										lastName: lastName,
										mobileNumber: mobileNumber,
										useEmailAsUsername: useEmailAsUsername,
										username: username,
										communicationPreference: communicationPreference)
	}
}


extension APIUserAddressModel {
	
	static func create(
		countryCode: String = "",
		state: String = "",
		street: String = "",
		zipCode: String = "",
		city: String = "") -> APIUserAddressModel {
		
		return APIUserAddressModel(countryCode: countryCode,
								   state: state,
								   province: nil,
								   street: street,
								   houseNo: nil,
								   zipCode: zipCode,
								   city: city,
								   streetType: nil,
								   houseName: nil,
								   floorNo: nil,
								   doorNo: nil,
								   addressLine1: nil,
								   addressLine2: nil,
								   addressLine3: nil,
								   postOfficeBox: nil)
	}
}

extension APIUserModel {
	
	static func create(
		address: APIUserAddressModel? = nil,
		ciamId: String = "",
		firstName: String = "",
		lastName1: String = "",
		createdAt: String = "",
		updatedAt: String = "",
        accountCountryCode: String = "",
        preferredLanguageCode: String = "") -> APIUserModel {
		
		return APIUserModel(ciamId: ciamId,
							firstName: firstName,
							lastName1: lastName1,
							lastName2: nil,
							title: nil,
							namePrefix: nil,
							middleInitial: nil,
							salutationCode: nil,
							email: nil,
							landlinePhone: nil,
							mobilePhoneNumber: nil,
							birthday: nil,
							preferredLanguageCode: preferredLanguageCode,
							accountCountryCode: accountCountryCode,
							createdAt: createdAt,
							createdBy: nil,
							updatedAt: updatedAt,
							address: address,
							communicationPreference: nil,
							userPinStatus: nil,
							unitPreferences: APIUserUnitPreferenceModel.create(),
							taxNumber: nil,
							accountIdentifier: nil,
							useEmailAsUsername: nil,
                            adaptionValues: nil,
                            accountVerified: nil,
                            isEmailVerified: nil,
                            isMobileVerified: nil,
                            toasConsents: nil,
                            nonce: nil)
	}
}

extension APIUserUnitPreferenceModel {
	
	static func create() -> APIUserUnitPreferenceModel {
		return APIUserUnitPreferenceModel(clockHours: nil,
										  consumptionCo: nil,
										  consumptionEv: nil,
										  consumptionGas: nil,
										  speedDistance: nil,
										  temperature: nil,
										  tirePressure: nil)
	}
}
