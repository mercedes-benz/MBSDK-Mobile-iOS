//
// Copyright (c) 2020 MBition GmbH. All rights reserved.
//

import XCTest
@testable import MBMobileSDK

class EndpointEndpointTests : XCTestCase {

    override class func setUp() {
        super.setUp()
    }

    override class func tearDown() {
        super.tearDown()
    }

    func test_modifiedStage() {
		
        MBMobileSDKEndpoint.modifiedStage = .prod
        XCTAssertNotNil(MBMobileSDKEndpoint.modifiedStage)
        XCTAssertEqual(MBMobileSDKEndpoint.modifiedStage, EndpointStage.prod)
        XCTAssertEqual(MBMobileSDKEndpoint.modifiedStage?.rawValue, "prod")
		
        MBMobileSDKEndpoint.modifiedStage = .mock
        XCTAssertNotNil(MBMobileSDKEndpoint.modifiedStage)
        XCTAssertEqual(MBMobileSDKEndpoint.modifiedStage, EndpointStage.mock)
        XCTAssertEqual(MBMobileSDKEndpoint.modifiedStage?.rawValue, "mock")
    }

    func test_modifiedRegion() {
		
        MBMobileSDKEndpoint.modifiedRegion = .ece
        XCTAssertEqual(MBMobileSDKEndpoint.modifiedRegion, EndpointRegion.ece)
        XCTAssertEqual(MBMobileSDKEndpoint.modifiedRegion?.rawValue, "ece")
    }
}
