//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of theft related attributes
public struct VehicleTheftModel {
	
    /// Last collision details
	public let collision: VehicleCollisionModel
    /// Status of interior protection sensor
	public let interiorProtectionSensorStatus: StatusAttributeType<ProtectionStatus, NoUnit>
    /// Indicates whether the vehicles keys are disabled or enabled.
    public let keyActivationState: StatusAttributeType<KeyActivationState, NoUnit>
    /// UTC timestamp of last theft alarm
    /// Range: 0..2^64-2
    public let lastTheftWarning: StatusAttributeType<Int, NoUnit>
    /// Indicator, where the current theft warning has been triggered
	public let lastTheftWarningReason: StatusAttributeType<TheftWarningReason, NoUnit>
    /// Current alarm state
	public let theftAlarmActive: StatusAttributeType<ActiveState, NoUnit>
    /// Status of overall alarm sensors
	public let theftSystemArmed: StatusAttributeType<ArmedState, NoUnit>
    /// Status of tow protection sensor
	public let towProtectionSensorStatus: StatusAttributeType<ProtectionStatus, NoUnit>
}
