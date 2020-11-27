//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - HornType

/// Config for remote vehicle finder

public enum HornType: Int, CaseIterable {
    case off = 0
    case lowVolume = 1
    case highVolume = 2
}

// MARK: - LightType

/// Config for remote vehicle finder

public enum LightType: Int, CaseIterable {
    case off = 0
    case dippedHeadLight = 1
    case warningLight = 2
}

// MARK: - SigposType

/// Config for remote vehicle finder

public enum SigposType: Int, CaseIterable {
    case lightOnly = 0
    case hornOnly = 1
    case lightAndHorn = 2
    case panicAlarm = 3
}
