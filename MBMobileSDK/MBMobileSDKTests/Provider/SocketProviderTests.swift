//
// Copyright (c) 2020 MBition GmbH. All rights reserved.
//

import XCTest
@testable import MBMobileSDK

class SocketProviderTests : XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSocketProvider_init() {
		
        let provider = DefaultSocketProvider(sdkVersion: "_._._")

        XCTAssertNotNil(provider)
        XCTAssertNotNil(provider.urlProvider)
    }

    func testSocketProvider_urlProviding_prod() {
		
        MBMobileSDKEndpoint.modifiedRegion = .ece
        MBMobileSDKEndpoint.modifiedStage = .prod

        let provider = DefaultSocketProvider(sdkVersion: "_._._")

        let urlProvider = provider.urlProvider
        XCTAssertNotNil(urlProvider)

        let expectedUrl = "wss://websocket-prod.risingstars.daimler.com/ws"
        let providedUrl = urlProvider.baseUrl

        XCTAssertFalse(providedUrl.isEmpty)
        XCTAssertEqual(providedUrl, expectedUrl)
    }

    func testSocketProvider_urlProviding_mock() {
		
        MBMobileSDKEndpoint.modifiedRegion = .ece
        MBMobileSDKEndpoint.modifiedStage = .mock

        let provider = DefaultSocketProvider(sdkVersion: "_._._")

        let urlProvider = provider.urlProvider
        XCTAssertNotNil(urlProvider)

        let expectedUrl = "wss://websocket-mock.risingstars-mock.daimler.com/ws"
        let providedUrl = urlProvider.baseUrl

        XCTAssertFalse(providedUrl.isEmpty)
        XCTAssertEqual(providedUrl, expectedUrl)
    }
}
