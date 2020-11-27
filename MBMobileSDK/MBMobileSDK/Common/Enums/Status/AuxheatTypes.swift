//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - AuxheatState

/// State for auxheat attribute state
public enum AuxheatState: Int, Codable, CaseIterable {
	case inactive = 0
	case heatingNormal = 1
	case ventilationNormal = 2
	case heatingManual = 3
	case heatingPost = 4
	case ventilationPost = 5
	case heatingAuto = 6
}

extension AuxheatState {
	
	public var toString: String {
		switch self {
		case .heatingAuto:			return "auto heating"
		case .heatingManual:		return "manual heating"
		case .heatingNormal:		return "normal heating"
		case .heatingPost:			return "post heating"
		case .inactive:				return "inactive"
		case .ventilationNormal:	return "normal ventilation"
		case .ventilationPost:		return "post ventialtion"
		}
	}
}


// MARK: - AuxheatTimeSelectionState

/// State for auxheat time selection attribute
public enum AuxheatTimeSelectionState: Int, Codable, CaseIterable {
	case none = 0
	case time1 = 1
	case time2 = 2
	case time3 = 3
}

extension AuxheatTimeSelectionState {
	
	public var toInt: Int {
		return Int(self.rawValue)
	}
	
	public var toString: String {
		switch self {
		case .none:		return "none"
		case .time1:	return "time1"
		case .time2:	return "time2"
		case .time3:	return "time3"
		}
	}
}


// MARK: - AuxheatWarningState

/// State for auxheat warning attribute as bitmask
public enum AuxheatWarningState: Int, Codable, CaseIterable {
	case none = 0
	case noBudget = 1
	case budgetEmpty = 2
	case systemError = 4
	case runningError = 8
	case fuelOnReserve = 16
	case reserveReached = 32
	case lowVoltage = 64
	case lowVoltageOperation = 128
	case communicationError = 256
}

extension AuxheatWarningState {
	
	public var toString: String {
		switch self {
		case .budgetEmpty:			return "budget empty"
		case .communicationError:	return "communication error"
		case .fuelOnReserve:		return "fuel on reserve"
		case .lowVoltage:			return "low voltage"
		case .lowVoltageOperation:	return "low voltage operation"
		case .noBudget:				return "no budget"
		case .none:					return "none"
		case .reserveReached:		return "reserve reached"
		case .runningError:			return "running error"
		case .systemError:			return "system error"
		}
	}
}
