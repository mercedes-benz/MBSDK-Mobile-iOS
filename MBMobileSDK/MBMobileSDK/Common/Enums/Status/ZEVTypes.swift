//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - BatteryChargeProgram

/// State for battery charging program

public enum BatteryChargeProgram: Int, CaseIterable {
	case `default` = 0
	case instant = 1
}


// MARK: - ChargingBreakClockTimerAction

/// State of charging break clock timer
public enum ChargingBreakClockTimer: Int, CaseIterable {
	case delete = 0
	case activate = 1
	case deactivate = 2
}

extension ChargingBreakClockTimer {
	
	public var toString: String {
		switch self {
		case .activate:		return "activate"
		case .deactivate:	return "deactivate"
		case .delete:		return "delete"
		}
	}
}


// MARK: - ChargingCouplerLockStatus

/// State of lock status for charging coupler
public enum ChargingCouplerLockStatus: Int, CaseIterable {
	case locked = 0
	case unlocked = 1
	case unknown = 2
}

extension ChargingCouplerLockStatus {
	
	public var toString: String {
		switch self {
		case .locked:	return "connector locked"
		case .unknown:	return "locking state not clear"
		case .unlocked:	return "connector unlocked"
		}
	}
}


// MARK: - ChargingCouplerStatus

/// State for charging coupler
public enum ChargingCouplerStatus: Int, CaseIterable {
    
    /// Charging wire plugged on both sides
	case pluggedBothSides = 0
    /// Charging wire plugged on vehicle side
	case pluggedVehicleSide = 1
    ///  Charging wire not plugged on vehicle side
	case notPluggedVehicleSide = 2
	case unknown = 3
	case unknownDueEffect = 4
}

extension ChargingCouplerStatus {
	
	public var toString: String {
		switch self {
		case .notPluggedVehicleSide:	return "not plugged on vehicle side"
		case .pluggedBothSides:			return "plugged on both sides"
		case .pluggedVehicleSide:		return "plugged on vehicle side"
		case .unknown:					return "unknown"
		case .unknownDueEffect:			return "unknown due effect"
		}
	}
}


// MARK: - ChargingError

/// State for charging error attribute
public enum ChargingError: Int, CaseIterable {
	case none = 0
    /// Unlock Charging cable not possible
	case cable = 1
    /// Charging error, please switch charging mode
	case chargingDisorder = 2
    /// Vehicle not charging. Charging station error
	case chargingStation = 3
    /// Charging mode not available. Please try again or switch charging mode
	case chargingType = 4
}

extension ChargingError {
	
	public var toString: String {
		switch self {
		case .cable:			return "cable"
		case .chargingDisorder:	return "charging disorder"
		case .chargingStation:	return "charging station"
		case .chargingType:		return "charging type"
		case .none:				return "no message"
		}
	}
}


// MARK: - ChargingErrorInfrastructure

/// State for charging error infrastructure
public enum ChargingErrorInfrastructure: Int, CaseIterable {
	case noError = 0
	case infrastructureErrorAC = 1
	case infrastructureErrorDC = 2
	case inductiveInfrastructureError = 3
	case infrastructureErrorACDC = 4
	case inductiveInfrastructureErrorAC = 5
	case inductiveInfrastructureErrorDC = 6
	case chargeError = 7
}

extension ChargingErrorInfrastructure {
	
	public var toString: String {
		switch self {
		case .chargeError:						return "chrg_err"
		case .inductiveInfrastructureError:		return "ind_infra_err"
		case .inductiveInfrastructureErrorAC:	return "ac_ind_infra_err"
		case .inductiveInfrastructureErrorDC:	return "dc_ind_infra_err"
		case .infrastructureErrorAC:			return "ac_infra_err"
		case .infrastructureErrorACDC:			return "ac_dc_infra_err"
		case .infrastructureErrorDC:			return "dc_infra_err"
		case .noError:							return "no_err"
		}
	}
}


// MARK: - ChargingErrorWim

/// State for charging error warning and information messages (WIM)
public enum ChargingErrorWim: Int, CaseIterable {
	case noError = 0
	case message1 = 1
	case message2 = 2
	case message3 = 3
	case message4 = 4
	case message5 = 5
	case message6 = 6
	case message7 = 7
	case message8 = 8
	case message9 = 9
	case message10 = 10
	case message11 = 11
	case message12 = 12
	case message13 = 13
	case message14 = 14
}

extension ChargingErrorWim {
	
	public var toString: String {
		switch self {
		case .message1:		return "message 1"
		case .message10:	return "message 10"
		case .message11:	return "message 11"
		case .message12:	return "message 12"
		case .message13:	return "message 13"
		case .message14:	return "message 14"
		case .message2:		return "message 2"
		case .message3:		return "message 3"
		case .message4:		return "message 4"
		case .message5:		return "message 5"
		case .message6:		return "message 6"
		case .message7:		return "message 7"
		case .message8:		return "message 8"
		case .message9:		return "message 9"
		case .noError:		return "no error"
		}
	}
}


// MARK: - ChargingFlapStatus

/// State for charging flap
public enum ChargingFlapStatus: Int, CaseIterable {
	case open = 0
	case closed = 1
	case pressed = 2
}

extension ChargingFlapStatus {
	
	public var toString: String {
		switch self {
		case .closed:	return "closed"
		case .open:		return "open"
		case .pressed:	return "flap pressed"
		}
	}
}


// MARK: - ChargingLimitation

/// State for ac charging limitation
public enum ChargingLimitation: CaseIterable {
	case limit6a
	case limit8a
	case noLimit
	case notDefined
	
	
	// MARK: - Init
	
	init(rawValue: Int?) {
		switch rawValue {
		case 0:		self = .limit6a
		case 1:		self = .limit8a
		case 6:		self = .noLimit
		default:	self = .notDefined  // range 2...5
		}
	}
}

extension ChargingLimitation {

	var rawValue: Int {
		switch self {
		case .limit6a:		return 0
		case .limit8a:		return 1
		case .noLimit:		return 6
		case .notDefined:	return 2
		}
	}
	
	public var toString: String {
		switch self {
		case .limit6a:		return "limit to 6A"
		case .limit8a:		return "limit to 8A"
		case .noLimit:		return "no limit"
		case .notDefined:	return "not defined"
		}
	}
}


// MARK: - ChargingMode

/// State for charging mode attribute
public enum ChargingMode: Int, CaseIterable {
	case none = 0
	case conductiveAC = 1
	case inductive = 2
	case conductiveACInductive = 3
	case conductiveDC = 4
}

extension ChargingMode {
	
	public var toString: String {
		switch self {
		case .conductiveAC:				return "conductive ac"
		case .conductiveACInductive:	return "conductive ac + inductive"
		case .conductiveDC:				return "conductive dc"
		case .inductive:				return "inductive"
		case .none:						return "none"
		}
	}
}


// MARK: - ChargingProgram

/// State for charging program attribute
public enum ChargingProgram: Int, CaseIterable {
	case `default` = 0
	case ìnstant = 1
	case home = 2
	case work = 3
}

extension ChargingProgram {
	
	public var toString: String {
		switch self {
		case .`default`:	return "default"
		case .home:			return "home"
		case .ìnstant:		return "instant"
		case .work:			return "work"
		}
	}
}


// MARK: - ChargingStatus

/// State for charging status attribute
public enum ChargingStatus: Int, CaseIterable {
	case charging = 0
	case chargingEnds = 1
	case chargeBreak = 2
	case unplugged = 3
	case failure = 4
	case slow = 5
	case fast = 6
	case discharging = 7
	case noCharging = 8
	case chargingForeignObject = 9
}

extension ChargingStatus {
	
	public var toString: String {
		switch self {
		case .chargeBreak:				return "charge break"
		case .charging:					return "charging"
		case .chargingEnds:				return "end of charge"
		case .chargingForeignObject:	return "ch. foreign obj."
		case .discharging:				return "discharging"
		case .failure:					return "charging failure"
		case .fast:						return "fast charging"
		case .noCharging:				return "no charging"
		case .slow:						return "slow charging"
		case .unplugged:				return "charge cable unplugged"
		}
	}
}


// MARK: - Day

/// State for day
public enum Day: Int, CaseIterable, Encodable, Decodable {
	case monday = 0
	case tuesday = 1
	case wednesday = 2
	case thursday = 3
	case friday = 4
	case saturday = 5
	case sunday = 6
}

extension Day {
	
	public var toString: String {
		switch self {
		case .friday:		return "Friday"
		case .monday:		return "Monday"
		case .saturday:		return "Saturday"
		case .sunday:		return "Sunday"
		case .thursday:		return "Thursday"
		case .tuesday:		return "Tuesday"
		case .wednesday:	return "Wednesday"
		}
	}
    
    public static func mapShifftedMinusOneDay(_ day: Int) -> Day? {

        let shifftedDay = day - 1
        return Day(rawValue: shifftedDay)
    }
    
    public func mapShifteddPlusOneDay() -> Int {
        
        return self.rawValue + 1
    }
}


// MARK: - DepartureTimeIcon

/// State for departure time icon for zev
public enum DepartureTimeIcon: Int, CaseIterable {
	case inactive = 0
	case activeAdhoc = 1
	case activeWeekDepartureTime = 2
	case skip = 3
	case activeTrip = 4
}

extension DepartureTimeIcon {
	
	public var toString: String {
		switch self {
		case .activeAdhoc:				return "active adhoc"
		case .activeTrip:				return "active trip"
		case .activeWeekDepartureTime:	return "active week dep.time"
		case .inactive:					return "inactive"
		case .skip:						return "skip"
		}
	}
}

// MARK: - DepartureTimeMode

/// State for departure time mode for zev
public enum DepartureTimeMode: Int, CaseIterable {
	case inactive = 0
	case active = 1
	case weekly = 2
}

extension DepartureTimeMode {
	
	public var toString: String {
		switch self {
		case .active:	return "adhoc active"
		case .inactive:	return "inactive"
		case .weekly:	return "weeklyset active"
		}
	}
}


// MARK: - DepartureTimeModeConfiguration

/// State for departure time mode for preconditioning configuration
public enum DepartureTimeModeConfiguration: Int, CaseIterable {
	case disabled = 0
	case single = 1
	case weekly = 2
}

/// State for departure time mode for preconditioning configuration
public enum DepartureTimeConfiguration: Int, CaseIterable {
	case disabled = 0
	case once = 1
	case weekly = 2
}


// MARK: - HybridWarningState

/// State for hybrid warning state
public enum HybridWarningState: Int, CaseIterable {
	case none = 0
	case seekServiceWithoutEngineStop = 1
	case highVoltagePowernetFault = 2
	case powertrainFault = 3
	case starterBattery = 4
	case stopVehicleChargeBattery = 5
	case pluginOnlyEmodePossible = 6
	case pluginVehicleStillActive = 7
	case powerReduce = 8
	case stopEngineOff = 9
}

extension HybridWarningState {
	
	public var toString: String {
		switch self {
		case .highVoltagePowernetFault:		return "high voltage powernet fault"
		case .none:							return "no request"
		case .pluginOnlyEmodePossible:		return "plugin: only e-mode possible"
		case .pluginVehicleStillActive:		return "plugin: vehicle still active"
		case .powerReduce:					return "power reduced"
		case .powertrainFault:				return "powertrain fault"
		case .seekServiceWithoutEngineStop:	return "seek service without engine stop"
		case .starterBattery:				return "starter battery"
		case .stopEngineOff:				return "stop, engine off"
		case .stopVehicleChargeBattery:		return "stop vehicle and charge battery"
		}
	}
}


// MARK: - PrecondError

/// State for the zev preconditioning error
public enum PrecondError: Int, CaseIterable {
    
    /// No request/attribute is changed
	case noRequest = 0
    /// PreConditioning not possible, battery low/fuel low(CH2)
	case batteryFuelLow = 1
    /// PreConditioning available after restart engine
	case restartEngine = 2
    /// PreConditioning not possible, charging not finished
	case notFinished = 3
    /// PreConditioning general error (SmartEdison)
	case general = 4
}

extension PrecondError {
	
	public var toString: String {
		switch self {
		case .batteryFuelLow:	return "battery or fuel low"
		case .general:			return "general error"
		case .noRequest:		return "no request"
		case .notFinished:		return "not possible, charging not finished"
		case .restartEngine:	return "available after restart engine"
		}
	}
}


// MARK: - PreconditioningType

/// State for the zev preconditioning command
public enum PreconditioningType: Int, CaseIterable {
	case unknown = 0
	case immediate = 1
	case departure = 2
	case now = 3
	case departureWeekly = 4
}


// MARK: - SmartCharging

/// State for smart charging
public enum SmartCharging: Int, CaseIterable {
    /// Wallbox (Ladesäule) is active
	case wallbox = 0
    /// Smart Charge Communication is active
	case smartCharge = 1
    /// On/Off-Peak setting is active (Tag-/Nachtstrom)
	case peakSetting = 2
}

extension SmartCharging {
	
	public var toString: String {
		switch self {
		case .peakSetting:	return "peak setting"
		case .smartCharge:	return "smart charge"
		case .wallbox:		return "wallbox"
		}
	}
}


// MARK: - SmartChargingDeparture

/// State for smart charging departure
public enum SmartChargingDeparture: Bool, CaseIterable {
	case inactive = 0
	case requested = 1
}

extension SmartChargingDeparture {
	
	public var toString: String {
		switch self {
		case .inactive:		return "inactive"
		case .requested:	return "requested"
		}
	}
}


// MARK: - TariffRate

/// State for tariff rate
public enum TariffRate: Int, CaseIterable {
	case invalidPrice = 0
	case lowPrice = 33
	case normalPrice = 44
	case highPrice = 66
}


// MARK: - TariffType

enum TariffType {
	case weekday
	case weekend
}
