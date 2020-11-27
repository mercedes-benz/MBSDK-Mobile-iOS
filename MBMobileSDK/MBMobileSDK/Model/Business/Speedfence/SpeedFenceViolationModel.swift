//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

public struct SpeedFenceViolationModel {
    public let coordinate: CoordinateModel?
    public let speedfence: SpeedFenceModel?
    public let onboardfence: OnboardFenceModel?
    public let time: Int?
    public let violationId: Int?
}
