//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - VehicleZEVModel

/// Representation of zev related attributes
public struct VehicleZEVModel {
	
    /// Display actual charging current limitation by customer
	public let acChargingCurrentLimitation: StatusAttributeType<ChargingLimitation, NoUnit>
    /// Activation status of bidirectional charging
	public let bidirectionalChargingActive: StatusAttributeType<ActiveState, NoUnit>
	public let chargeCouplerACLockStatus: StatusAttributeType<ChargingCouplerLockStatus, NoUnit>
	public let chargeCouplerACStatus: StatusAttributeType<ChargingCouplerStatus, NoUnit>
	public let chargeCouplerDCLockStatus: StatusAttributeType<ChargingCouplerLockStatus, NoUnit>
	public let chargeCouplerDCStatus: StatusAttributeType<ChargingCouplerStatus, NoUnit>
	public let chargeFlapACStatus: StatusAttributeType<ChargingFlapStatus, NoUnit>
	public let chargeFlapDCStatus: StatusAttributeType<ChargingFlapStatus, NoUnit>
    /// Current parameters for charging programs.
    public let chargePrograms: StatusAttributeType<[VehicleChargeProgramModel], NoUnit>
	public let chargingActive: StatusAttributeType<ActiveState, NoUnit>
	public let chargingBreakClockTimer: StatusAttributeType<[VehicleChargingBreakClockTimerModel], NoUnit>
	public let chargingError: StatusAttributeType<ChargingError, NoUnit>
	public let chargingErrorInfrastructure: StatusAttributeType<ChargingErrorInfrastructure, NoUnit>
    /// Charging error warning and information messages (WIM)
	public let chargingErrorWim: StatusAttributeType<ChargingErrorWim, NoUnit>
	public let chargingMode: StatusAttributeType<ChargingMode, NoUnit>
    /// Current charging Power in kW (only valid while charging)
    /// Range: -102.4..309.2
	public let chargingPower: StatusAttributeType<Double, NoUnit>
    /// Remote control of EV charging power by back-end use cases.
	public let chargingPowerControl: StatusAttributeType<VehicleChargingPowerControlModel, NoUnit>
    /// Max. charging power when ECO charging is active.
    /// 0..1021 kW
    /// Range: 0..1023
	public let chargingPowerEcoLimit: StatusAttributeType<Int, NoUnit>
	public let chargingStatus: StatusAttributeType<ChargingStatus, NoUnit>
    /// Display flag absolute or relative charging time
	public let chargingTimeType: StatusAttributeType<TimeType, NoUnit>
    /// Departure time in minutes from midnight (vehicle HeadUnit time)
    /// Range: 0..1439
	public let departureTime: StatusAttributeType<Int, ClockHourUnit>
    /// PNHV departure time icon display request
	public let departureTimeIcon: StatusAttributeType<DepartureTimeIcon, NoUnit>
	public let departureTimeMode: StatusAttributeType<DepartureTimeMode, NoUnit>
    /// State of charge at departure time in percent
    /// Range: 0.0..100.0
	public let departureTimeSoc: StatusAttributeType<Int, RatioUnit>
	public let departureTimeWeekday: StatusAttributeType<Day, NoUnit>
    /// End of charge time counted in minutes from midnight (vehicle HeadUnit time)
    /// Range: 0..1439
	public let endOfChargeTime: StatusAttributeType<Int, ClockHourUnit>
    /// End of relative charge time in minutes from midnight (vehicle HeadUnit time)
    /// Range: 0..1439
	public let endOfChargeTimeRelative: StatusAttributeType<Double, ClockHourUnit>
	public let endOfChargeTimeWeekday: StatusAttributeType<Day, NoUnit>
	public let hybridWarnings: StatusAttributeType<HybridWarningState, NoUnit>
	public let isActive: StatusAttributeType<ActiveState, NoUnit>
    /// Max. electrical range with 100% State of Charge in given distance unit
    /// Range: 0..1500
	public let maxRange: StatusAttributeType<Int, DistanceUnit>
    /// EMM maximum SOC display request
    /// Maximum HV battery State of Charge in percent as set in vehicle
    /// Range: 0..100
	public let maxSoc: StatusAttributeType<Int, RatioUnit>
    /// Maximum HV battery SOC lower limit in percent as calculated by vehicle
    /// Range: 0..100
	public let maxSocLowerLimit: StatusAttributeType<Int, RatioUnit>
    /// Maximum HV battery SOC upper limit as calculated by vehicle.
    /// Range: 0..100 %
	public let maxSocUpperLimit: StatusAttributeType<Int, RatioUnit>
    /// EMM minimum SOC display request
    /// 0..100 % minimum HV battery SOC as set in vehicle
    /// Range: 0..100
	public let minSoc: StatusAttributeType<Int, RatioUnit>
    /// EMM minimum SOC lower limit request
    /// 0..100 % minimum HV battery SOC lower limit as calculated by vehicle
	public let minSocLowerLimit: StatusAttributeType<Int, RatioUnit>
    /// Minimum HV battery SOC upper limit as calculated by vehicle.
    /// Range: 0..100 %
	public let minSocUpperLimit: StatusAttributeType<Int, RatioUnit>
    /// 0..1439: Departure time counted in minutes from midnight depending on vtime
    /// -1: departure time inactive (< Star 3 only)
    /// Range: -1..1439
	public let nextDepartureTime: StatusAttributeType<Int, ClockHourUnit>
	public let nextDepartureTimeWeekday: StatusAttributeType<Day, NoUnit>
	public let precondActive: StatusAttributeType<ActiveState, NoUnit>
	public let precondAtDeparture: StatusAttributeType<ActiveState, NoUnit>
    /// Preconditioning disabled because of too many trials triggered by week profile
	public let precondAtDepartureDisable: StatusAttributeType<DisableState, NoUnit>
    /// Preconditioning runtime in minutes
    /// Range: 0..254
	public let precondDuration: StatusAttributeType<Int, NoUnit>
	public let precondError: StatusAttributeType<PrecondError, NoUnit>
    /// Immediate preconditioning
	public let precondNow: StatusAttributeType<ActiveState, NoUnit>
	public let precondNowError: StatusAttributeType<PrecondError, NoUnit>
    /// Seat preconditioning front left
	public let precondSeatFrontLeft: StatusAttributeType<OnOffState, NoUnit>
    /// Seat preconditioning front right
	public let precondSeatFrontRight: StatusAttributeType<OnOffState, NoUnit>
    /// Seat preconditioning rear left
	public let precondSeatRearLeft: StatusAttributeType<OnOffState, NoUnit>
    /// Seat preconditioning rear right
	public let precondSeatRearRight: StatusAttributeType<OnOffState, NoUnit>
    /// Predicted charge level at the continuation of the trip for assisted routes in %
    /// Range: 0..1023
	public let rangeAssistDriveOnSoc: StatusAttributeType<Int, RatioUnit>
    ///Predicted continuation of the trip for assisted routes as Unix timestamp (local time)
    /// Range: 0..2^32-1
	public let rangeAssistDriveOnTime: StatusAttributeType<Int, NoUnit>
	public let selectedChargeProgram: StatusAttributeType<ChargingProgram, NoUnit>
	public let smartCharging: StatusAttributeType<SmartCharging, NoUnit>
	public let smartChargingAtDeparture: StatusAttributeType<SmartChargingDeparture, NoUnit>
	public let smartChargingAtDeparture2: StatusAttributeType<SmartChargingDeparture, NoUnit>
    /// State of Charge history as list of value-timestamp pairs
	public let socProfile: StatusAttributeType<[VehicleZEVSocProfileModel], NoUnit>
    /// Temperatures inside the vehicle for individual temperature zones
	public let temperature: VehicleZEVTemperatureModel
    /// List of Tariffs for weekdays
	public let weekdayTariff: StatusAttributeType<[VehicleZEVTariffModel], NoUnit>
    /// List of Tariffs for weekends
	public let weekendTariff: StatusAttributeType<[VehicleZEVTariffModel], NoUnit>
}
