//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of fuel related attributes
public struct VehicleTankModel {
	
    /// Tanklevel Ad Blue in percent
    /// Range: 0..100
	public let adBlueLevel: StatusAttributeType<Int, RatioUnit>
    /// Electric Level in percent
    /// Ranke: 0..100
	public let electricLevel: StatusAttributeType<Int, RatioUnit>
    /// Remaining range electric engine in given distance unit
    /// Range: 0..4000
	public let electricRange: StatusAttributeType<Int, DistanceUnit>
    /// Gas tanklevel in given unit. For LPG and hydrogen vehicles.
    /// Range: 0..204.6
	public let gasLevel: StatusAttributeType<Double, RatioUnit>
    /// Gas tankrange in given distance unit. For LPG and hydrogen vehicles.
    /// Range: 0..2046
	public let gasRange: StatusAttributeType<Double, DistanceUnit>
    /// Tanklevel in given unit. For combustion vehicles.
    /// Range: 0..100
	public let liquidLevel: StatusAttributeType<Int, RatioUnit>
    /// Remaining milage in given distance unit
    /// Range: 0..4000
	public let liquidRange: StatusAttributeType<Int, DistanceUnit>
	/// The range combined over all fuel types.
	public let overallRange: StatusAttributeType<Double, DistanceUnit>
}
