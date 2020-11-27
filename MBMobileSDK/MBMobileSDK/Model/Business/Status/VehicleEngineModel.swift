//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of engine related attributes
public struct VehicleEngineModel {
	
    /// State of ignition
	public let ignitionState: StatusAttributeType<IgnitionState, NoUnit>
    /// Remote Start End Time in seconds since 1.1.1970 00:00:00
    /// Range: 0..2^64-2
	public let remoteStartEndtime: StatusAttributeType<Int, NoUnit>
    /// State of remote start
	public let remoteStartIsActive: StatusAttributeType<RemoteStartActiveState, NoUnit>
    /// Remote Start inside Temperature (steps in 0.5°C)
    /// Range: -40.0..85.0
	public let remoteStartTemperature: StatusAttributeType<Double, TemperatureUnit>
    /// State of engine
	public let state: StatusAttributeType<EngineState, NoUnit>
}
