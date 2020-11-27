//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - VehicleTireModel

/// Representation of tire related attributes
public struct VehicleTireModel {
	
     /// Tire pressure in given pressure unit
     /// Range: 0..632.5
	public let pressure: StatusAttributeType<Double, PressureUnit>
    /// Current tire pressure warning
	public let warningLevel: StatusAttributeType<TireMarkerWarning, NoUnit>
}


// MARK: - VehicleTiresModel

/// Representation of tires related attributes
public struct VehicleTiresModel {
	
    /// Tire details (pressure, warnings) for front left wheel
	public let frontLeft: VehicleTireModel
    /// Tire details (pressure, warnings) for front right wheel
	public let frontRight: VehicleTireModel
    /// Latest pressure measurement UTC timestamp in seconds
	public let pressureMeasurementTimestamp: StatusAttributeType<Int, NoUnit>
    /// Tire details (pressure, warnings) for rear left wheel
	public let rearLeft: VehicleTireModel
    /// Tire details (pressure, warnings) for rear right wheel
	public let rearRight: VehicleTireModel
    /// Health indicator of all tire sensors, e.g. 'all available' or 'one to three missing'
	public let sensorAvailable: StatusAttributeType<TireSensorState, NoUnit>
    /// Overall tire pressure warning state, e.g. 'no warning' or 'low pressure'
	public let warningLevelOverall: StatusAttributeType<TireMarkerWarning, NoUnit>
}
