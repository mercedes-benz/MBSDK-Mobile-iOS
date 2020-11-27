//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of auxheat related attributes
public struct VehicleAuxheatModel {
	
	public let isActive: StatusAttributeType<ActiveState, NoUnit>
    /// Auxiliary heating remaining runtime:
    /// Range: 0..60 minutes
	public let runtime: StatusAttributeType<Int, NoUnit>
    /// Current auxiliary heating state
	public let state: StatusAttributeType<AuxheatState, NoUnit>
    /// Auxiliary heating pre-selection timer 1 in minutes from begin of day
    /// Range: 0..1439
	public let time1: StatusAttributeType<Int, ClockHourUnit>
    /// Auxiliary heating pre-selection timer 2 in minutes from begin of day
    /// Range: 0..1439
	public let time2: StatusAttributeType<Int, ClockHourUnit>
    /// Auxiliary heating pre-selection timer 3 in minutes from begin of day
    /// Range: 0..1439
	public let time3: StatusAttributeType<Int, ClockHourUnit>
    /// One out of NONE, TIME1, TIME2, TIME3, UNKNOWN
	public let timeSelection: StatusAttributeType<AuxheatTimeSelectionState, NoUnit>
    /// Warning for e.g. tank reserve reached
	public let warnings: StatusAttributeType<AuxheatWarningBitmask, NoUnit>
}
