//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of zev temperature zone related attributes
public struct VehicleZEVTemperatureModel {
	
    /// Temperature front center in given temperature unit
    /// Range: 0..30
	public let frontCenter: StatusAttributeType<Double, TemperatureUnit>
    /// Temperature front left in given temperature unit
    /// Range: 0..30
	public let frontLeft: StatusAttributeType<Double, TemperatureUnit>
    /// Temperature front right in given temperature unit
    /// Range: 0..30
	public let frontRight: StatusAttributeType<Double, TemperatureUnit>
    /// Temperature rear center (1) in given temperature unit
    /// Range: 0..30
	public let rearCenter: StatusAttributeType<Double, TemperatureUnit>
    /// Temperature rear center (2) in given temperature unit
    /// Range: 0..30
	public let rearCenter2: StatusAttributeType<Double, TemperatureUnit>
    /// Temperature rear left in given temperature unit
    /// Range: 0..30
	public let rearLeft: StatusAttributeType<Double, TemperatureUnit>
    /// Temperature rear right in given temperature unit
    /// Range: 0..30
	public let rearRight: StatusAttributeType<Double, TemperatureUnit>
}
