//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - TireLampState

/// State for tire lamp attribute
public enum TireLampState: Int, Codable, CaseIterable {
	case inactive = 0
	case triggered = 1
	case flashing = 2
}

extension TireLampState {
	
	public var toString: String {
		switch self {
		case .flashing:		return "flashing"
		case .inactive:		return "inactive"
		case .triggered:	return "triggered"
		}
	}
}


// MARK: - TireLevelPrwWarning

/// State for tire marker attribute
public enum TireLevelPrwWarning: Int, Codable, CaseIterable {
	case none = 0
	case warning = 1
	case workshop = 2
}

extension TireLevelPrwWarning {
	
	public var toString: String {
		switch self {
		case .none:		return "no warning"
		case .warning:	return "warning"
		case .workshop:	return "go to workshop"
		}
	}
}


// MARK: - TireMarkerWarning

/// State for tire marker attribute
public enum TireMarkerWarning: Int, Codable, CaseIterable {
	case none = 0
	case soft = 1
	case low = 2
	case deflation = 3
	case mark = 4
}

extension TireMarkerWarning {
	
	public var toString: String {
		switch self {
		case .deflation:	return "deflation"
		case .low:			return "low warning"
		case .mark:			return "unknown warning"
		case .none:			return "no warning"
		case .soft:			return "soft warning"
		}
	}
}


// MARK: - TireSensorState

/// State for tire sensor attribute
public enum TireSensorState: Int, Codable, CaseIterable {
	case allLocated = 0
	case missingSome = 1
	case missingAll = 2
	case error = 3
    case autolocateError = 4
}


// MARK: - Extension

extension TireSensorState {
	
	public var toString: String {
        switch self {
        case .allLocated:	    return "all sensors located"
        case .error:			return "system error"
        case .missingAll:	    return "1-3 sensors are missing"
        case .missingSome:	    return "all sensors missing"
        case .autolocateError:  return "autolocate error"
        }
	}
}
