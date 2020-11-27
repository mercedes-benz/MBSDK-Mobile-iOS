//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import XCTest
@testable import MBMobileSDK
@testable import MBNetworkKit

class ResultEnumTest: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	
	// MARK: - Tests
	
	func testIsFailedLoginResult() {
		
        let error = MBError(description: LoginError.noEnviroment.localizedDescription, type: MBErrorType.unknown)
        let result = Result<String, MBError>.failure(error)
        XCTAssertFalse(result.isSuccess)
	}
	
	func testIsSuccessValueResult() {
		
        let result = Result<String, MBError>.success("")
        XCTAssertTrue(result.isSuccess)
	}
}

extension Result {
    
    var isSuccess: Bool {
        switch self{
        case .failure:  return false
        case .success:  return true
        }
    }
}
