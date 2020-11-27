//
//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - APICustomerFenceViolationsModel
struct APICustomerFenceViolationModel: Codable {
    let violationid: Int?
    let time: Int?
    let coordinates: CoordinateModel?
    let customerfence: APICustomerFenceModel?
    let onboardfence: APIOnboardFenceModel?
}
