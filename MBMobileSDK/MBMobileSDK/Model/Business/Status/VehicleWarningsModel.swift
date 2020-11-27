//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of warnings related attributes
public struct VehicleWarningsModel {
	
	public let brakeFluid: StatusAttributeType<WarningState, NoUnit>
	public let brakeLiningWear: StatusAttributeType<WarningState, NoUnit>
	public let coolantLevelLow: StatusAttributeType<WarningState, NoUnit>
	public let electricalRangeSkipIndication: StatusAttributeType<RangeSkipStatus, NoUnit>
	public let engineLight: StatusAttributeType<WarningState, NoUnit>
	public let liquidRangeSkipIndication: StatusAttributeType<RangeSkipStatus, NoUnit>
	public let tireLamp: StatusAttributeType<TireLampState, NoUnit>
    /// Tire level plattrollwarner warning
	public let tireLevelPrw: StatusAttributeType<TireLevelPrwWarning, NoUnit>
	public let tireSprw: StatusAttributeType<WarningState, NoUnit>
	public let washWater: StatusAttributeType<WarningState, NoUnit>
}
