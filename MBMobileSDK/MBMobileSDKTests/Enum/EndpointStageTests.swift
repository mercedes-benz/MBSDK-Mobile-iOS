//
// Copyright (c) 2019 MBition GmbH. All rights reserved.
//

import XCTest
@testable import MBMobileSDK

class EndpointStageTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testReturnStageMock_shouldReturnValidTile() {
        XCTAssertEqual(EndpointStage.mock.title, "Mock")
    }

    func testReturnStageProd_shouldReturnValidTile() {
        XCTAssertEqual(EndpointStage.prod.title, "Prod")
    }
}
