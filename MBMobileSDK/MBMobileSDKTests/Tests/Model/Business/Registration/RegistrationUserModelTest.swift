//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import XCTest
@testable import MBMobileSDK

class RegistrationUserModelTest: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	
	// MARK: - Tests
	
	func testRegistrationUserModelExtensions() {
		
		let firstName = "TestA"
		let lastName  = "TestB"
		let name      = firstName + " " + lastName
		let userModel = RegistrationUserModel.create(firstName: firstName, lastName: lastName)
		
		XCTAssertTrue(userModel.name == name)
	}
}


// MARK: - RegistrationUserModel

extension RegistrationUserModel {
	
	static func create(
		countryCode: String = "",
		email: String = "",
		firstName: String = "",
		lastName: String = "",
		mobileNumber: String = "",
		password: String = "",
		useEmailAsUsername: Bool = true,
		userName: String = "") -> RegistrationUserModel {
		
		return RegistrationUserModel(countryCode: countryCode,
									 email: email,
									 firstName: firstName,
									 lastName: lastName,
									 mobileNumber: mobileNumber,
									 useEmailAsUsername: useEmailAsUsername,
									 userName: userName)
	}
}
