//
// Copyright (c) 2020 MBition GmbH. All rights reserved.
//

import XCTest
@testable import MBMobileSDK

class CdnProviderTests: XCTestCase {

    override class func setUp() {
        super.setUp()
    }

    override class func tearDown() {
        super.tearDown()
    }

    func testCdnProvider_urlProviding_prod() {
		
        MBMobileSDKEndpoint.modifiedRegion = .ece
        MBMobileSDKEndpoint.modifiedStage = .prod

        let provider = DefaultCdnUrlProvider()

        let expectedUrl = "https://vehicle-topview.azureedge.net"
        let providedUrl = provider.baseUrl
        XCTAssertFalse(provider.baseUrl.isEmpty)
        XCTAssertEqual(expectedUrl, providedUrl)
    }

    func testCdnProvider_urlProviding_mock() {
		
        MBMobileSDKEndpoint.modifiedRegion = .ece
        MBMobileSDKEndpoint.modifiedStage = .mock
        
        let provider = DefaultCdnUrlProvider()

        let expectedUrl = "https://vehicle-topview-int.azureedge.net"
        let providedUrl = provider.baseUrl
        XCTAssertFalse(provider.baseUrl.isEmpty)
        XCTAssertEqual(expectedUrl, providedUrl)
    }
}
