//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - CustomerFenceViolationsModel
public struct CustomerFenceViolationModel {
    let violationid: Int?
    /// UTC timestamp in seconds (ISO 9945)
    let time: Int?
    let coordinates: CoordinateModel?
    let customerfence: CustomerFenceModel?
    let onboardfence: OnboardFenceModel?
}
