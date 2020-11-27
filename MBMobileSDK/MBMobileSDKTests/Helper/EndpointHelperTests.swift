//
// Copyright (c) 2020 MBition GmbH. All rights reserved.
//

import XCTest
@testable import MBMobileSDK

class EndpointHelperTests: XCTestCase {

    override class func setUp() {
        super.setUp()
    }

    override class func tearDown() {
        super.tearDown()
    }

    func testUrlRegionString_prod_ece() {
		
        MBMobileSDKEndpoint.modifiedStage = .prod
        MBMobileSDKEndpoint.modifiedRegion = .ece
        XCTAssertEqual(EndpointHelper.urlRegionString, "")
    }

    func testUrlRegionString_mock_ece() {
		
        MBMobileSDKEndpoint.modifiedStage = .mock
        MBMobileSDKEndpoint.modifiedRegion = .ece
        XCTAssertEqual(EndpointHelper.urlRegionString, "-mock")
    }
}
