//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of vehicle related attributes
public struct VehicleVehicleModel {
	
    /// Connection status of the vehicle. Only for Fastpath vehicles.
	public let dataConnectionState: StatusAttributeType<Double, NoUnit>
    /// Open status of the engine hood
	public let engineHoodStatus: StatusAttributeType<OpenCloseState, NoUnit>
    /// Air quality state
	public let filterParticaleState: StatusAttributeType<FilterParticleState, NoUnit>
    /// Odometer, value in km
    /// Range: 0..999999
	public let odo: StatusAttributeType<Int, DistanceUnit>
    /// Lock status for gas
	public let lockGasState: StatusAttributeType<LockStatus, NoUnit>
    /// Parking brake status
	public let parkBrakeStatus: StatusAttributeType<ActiveState, NoUnit>
    /// Lock status for rooftop
	public let roofTopState: StatusAttributeType<RoofTopState, NoUnit>
    /// Residual maintenance interval days
    /// Range: -1998..1998
	public let serviceIntervalDays: StatusAttributeType<Int, NoUnit>
    /// Residual maintenance interval distance in given distance unit
    /// Range: -199999..199999
	public let serviceIntervalDistance: StatusAttributeType<Int, DistanceUnit>
    /// Displayed battery state of charge (HV battery) in percent
    /// Range: 0..100
	public let soc: StatusAttributeType<Int, RatioUnit>
    public let speedAlert: StatusAttributeType<[VehicleSpeedAlertModel], NoUnit>
    /// Vehicle speed unit
	public let speedUnitFromIC: StatusAttributeType<SpeedUnitType, NoUnit>
    /// Current state of the starter battery
	public let starterBatteryState: StatusAttributeType<StarterBatteryState, NoUnit>
    /// Vehicle time as timestamp in seconds since 1.1.1970 00:00:00
	public let time: StatusAttributeType<Int, NoUnit>
    /// Lock status for door
	public let vehicleLockState: StatusAttributeType<VehicleLockStatus, NoUnit>
}
