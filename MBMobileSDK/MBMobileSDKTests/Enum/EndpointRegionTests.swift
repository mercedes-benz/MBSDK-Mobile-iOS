//
// Copyright (c) 2019 MBition GmbH. All rights reserved.
//

import XCTest
@testable import MBMobileSDK

class EndpointRegionTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testReturnRegionEce_shouldReturnValidTile() {
		
		XCTAssertEqual(EndpointRegion.ece.title, "ECE")
		XCTAssertEqual(EndpointRegion.ece.rawValue, "ece")
    }
}
