//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of eco score related attributes
public struct VehicleEcoScoreModel {
	
    /// Rating acceleration percentage points (0% - 100%)
    /// Range: 0..100
	public let accel: StatusAttributeType<Int, RatioUnit>
    /// Rating bonus range in km
    /// Range: 0..1638.0
	public let bonusRange: StatusAttributeType<Double, DistanceUnit>
    /// Rating constancy percentage points (0% - 100%)
    /// Range: 0..100
	public let const: StatusAttributeType<Int, RatioUnit>
    /// Rating free wheeling percentage points (0% - 100%)
    /// Range: 0..100
	public let freeWhl: StatusAttributeType<Int, RatioUnit>
    /// Overall rating percentage points (0% - 100%)
    /// Range: 0..100
	public let total: StatusAttributeType<Int, RatioUnit>
}
