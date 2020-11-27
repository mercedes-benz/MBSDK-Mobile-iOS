//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of zev charging break clock timer related attributes
public struct VehicleChargingBreakClockTimerModel {
	
	public let action: ChargingBreakClockTimer
    /// End time (hour) when charging break shall be applied, valid value range: 0-23
	public let endTimeHour: Int
    /// End time (minute) when charging break shall be applied, valid value range: 0-59
	public let endTimeMin: Int
    /// Start time (hour) when charging break shall be applied, valid value range: 0-23
	public let startTimeHour: Int
    /// Start time (minute) when charging break shall be applied, valid value range: 0-59
	public let startTimeMin: Int
    /// Id which timer slot is used, valid value range: 1-4
	public let timerId: Int
}
