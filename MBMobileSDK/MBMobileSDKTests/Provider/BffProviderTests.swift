//
// Copyright (c) 2020 MBition GmbH. All rights reserved.
//

import XCTest
@testable import MBMobileSDK

class BffProviderTests : XCTestCase {

    override class func setUp() {
        super.setUp()
    }

    override class func tearDown() {
        super.tearDown()
    }

    func testBffProvider_init() {

        let provider = DefaultBffProvider(sdkVersion: "_._._")

        XCTAssertNotNil(provider.sessionId)
        XCTAssertFalse(provider.sessionId.isEmpty)
    }

    func testBffProvider_urlProviding_mock() {

        MBMobileSDKEndpoint.modifiedStage = .mock
        MBMobileSDKEndpoint.modifiedRegion = .ece

        let provider = DefaultBffProvider(sdkVersion: "_._._")

        let urlProvider = provider.urlProvider
        XCTAssertNotNil(urlProvider)

        let expectedUrl = "https://bff-mock.risingstars-mock.daimler.com/v1"
        XCTAssertEqual(urlProvider.baseUrl, expectedUrl)
    }

    func testBffProvider_urlProviding_prod() {

        MBMobileSDKEndpoint.modifiedStage = .prod
        MBMobileSDKEndpoint.modifiedRegion = .ece

        let provider = DefaultBffProvider(sdkVersion: "_._._")

        let urlProvider = provider.urlProvider
        XCTAssertNotNil(urlProvider)

        let expectedUrl = "https://bff-prod.risingstars.daimler.com/v1"
        XCTAssertEqual(urlProvider.baseUrl, expectedUrl)
    }
}
