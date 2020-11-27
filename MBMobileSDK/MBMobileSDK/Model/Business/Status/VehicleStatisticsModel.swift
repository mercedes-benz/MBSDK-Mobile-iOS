//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - VehicleStatisticsModel

/// Representation of statistic related attributes
public struct VehicleStatisticsModel {
	
    /// Average speed since start/reset
    /// Range: 0..405.0
	public let averageSpeed: VehicleStatisticResetStartDoubleModel<SpeedUnit>
    /// Distance since start/reset
	public let distance: VehicleStatisticDistanceModel
    /// Driven Time since start/reset in minutes
	public let drivenTime: VehicleStatisticDrivenTimeModel
    /// Statistics of electrical (battery) consumption & driven distance since start/reset
    /// - Consumption in given consumption unit, Range: 0..250.0
    /// - Distance in given distance unit, Range: 0..999999.9
	public let electric: VehicleStatisticTankModel<ElectricityConsumptionUnit, DistanceUnit>
    /// Statistics of gas (LPG/H2) consumption & driven distance since start/reset
    /// - Consumption in given consumption unit, Range: 0..100.0
    /// - Distance in given distance unit, Range: 0..999999.9
	public let gas: VehicleStatisticTankModel<GasConsumptionUnit, DistanceUnit>
    /// Statistics of liquid (combustion vehicles) consumption & driven distance since start/reset
    /// - Consumption in given consumption unit, Range: 0..100.0
    /// - Distance in given distance unit, Range: 0..999999.9
	public let liquid: VehicleStatisticTankModel<CombustionConsumptionUnit, DistanceUnit>
}


// MARK: - VehicleStatisticDistanceModel

/// Representation of statistic based distance related attributes
public struct VehicleStatisticDistanceModel {
	
	public let reset: StatusAttributeType<Double, DistanceUnit>
	public let start: StatusAttributeType<Double, DistanceUnit>
	public let ze: VehicleStatisticResetStartIntModel<DistanceUnit>
}


// MARK: - VehicleStatisticDrivenTimeModel

/// Representation of statistic based driven time related attributes
public struct VehicleStatisticDrivenTimeModel {
	
	public let reset: StatusAttributeType<Int, NoUnit>
	public let start: StatusAttributeType<Int, NoUnit>
	public let ze: VehicleStatisticResetStartIntModel<NoUnit>
}


// MARK: - VehicleStatisticResetStartDoubleModel

/// Representation of statistic based reset start related attributes
public struct VehicleStatisticResetStartDoubleModel<T> {
	
	public let reset: StatusAttributeType<Double, T>
	public let start: StatusAttributeType<Double, T>
}


// MARK: - VehicleStatisticResetStartIntModel

/// Representation of statistic based reset start related attributes
public struct VehicleStatisticResetStartIntModel<T> {
	
	public let reset: StatusAttributeType<Int, T>
	public let start: StatusAttributeType<Int, T>
}
