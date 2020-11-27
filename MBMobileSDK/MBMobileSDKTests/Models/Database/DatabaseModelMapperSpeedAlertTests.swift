//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import XCTest

@testable import MBMobileSDK

class DatabaseModelMapperSpeedAlertTests: XCTestCase {

    private struct Constants {
        static let endtime: Int = 23
        static let threshold: Int = 11
        static let thresholdDisplayValue: String = "11"
    }

    // MARK: - Tests

    func testMapVehicleStatusSpeedAlertModel() {
		
        let speedAlertModel = VehicleSpeedAlertModel(endtime: Constants.endtime,
													 threshold: Constants.threshold,
													 thresholdDisplayValue: Constants.thresholdDisplayValue)

        let mappedSpeedAlertModel = VehicleStatusDbModelMapper().map(vehicleStatusSpeedAlertModel: speedAlertModel)
        XCTAssertEqual(mappedSpeedAlertModel.endTime, Int64(Constants.endtime))
        XCTAssertEqual(mappedSpeedAlertModel.threshold, Int64(Constants.threshold))
        XCTAssertEqual(mappedSpeedAlertModel.thresholdDisplayValue, Constants.thresholdDisplayValue)
    }
}
