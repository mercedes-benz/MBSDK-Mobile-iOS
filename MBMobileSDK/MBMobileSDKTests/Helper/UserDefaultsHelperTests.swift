//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import XCTest
@testable import MBMobileSDK

class UserDefaultsHelperTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testModifiedStage_value_shouldReturnValue() {
		
        let value = EndpointStage.mock
		UserDefaultsHelper.modifiedStage = value.rawValue
		let newValue = EndpointStage(rawValue: UserDefaultsHelper.modifiedStage ?? "")
		XCTAssertEqual(value, newValue)
    }

    func testModifiedStage_nilValue_shouldReturnNil() {
		
		UserDefaultsHelper.modifiedStage = EndpointStage.mock.rawValue
        UserDefaultsHelper.modifiedStage = nil
        XCTAssertNil(UserDefaultsHelper.modifiedStage)
    }

    func testModifiedRegion_value_shouldReturnValue() {
		
        let value = EndpointRegion.ece
		UserDefaultsHelper.modifiedRegion = value.rawValue
		let newValue = EndpointRegion(rawValue: UserDefaultsHelper.modifiedRegion ?? "")
		XCTAssertEqual(value, newValue)
    }

    func testModifiedRegion_nilValue_shouldReturnNil() {
		
		UserDefaultsHelper.modifiedRegion = EndpointRegion.ece.rawValue
        UserDefaultsHelper.modifiedRegion = nil
        XCTAssertNil(UserDefaultsHelper.modifiedRegion)
    }
}
