//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - SunroofEventState

/// State for sun roof event attribute
public enum SunroofEventState: Int, Codable, CaseIterable {
	case none = 0
	case rainLiftPosition = 1
	case automaticLiftPosition = 2
	case ventilationPosition = 3
}

extension SunroofEventState {
	
	public var toString: String {
		switch self {
		case .automaticLiftPosition:	return "automatic lift position"
		case .none:						return "no event"
		case .rainLiftPosition:			return "rain lift position"
		case .ventilationPosition:		return "ventilation position (timer expired)"
		}
	}
}


// MARK: - SunroofStatus

/// State for sun roof attribute
public enum SunroofStatus: Int, Codable, CaseIterable {
	case closed = 0
	case open = 1
	case openLifting = 2
	case running = 3
	case antiBooming = 4
	case intermediateSliding = 5
	case intermediateLifting = 6
	case opening = 7
	case closing = 8
	case antiBoomingLifting = 9
	case intermediatePosition = 10
	case openingLifting = 11
	case closingLifting = 12
}

extension SunroofStatus {
	
	public var stateString: String {
		switch self {
		case .antiBooming:			return "anti-booming position"
		case .antiBoomingLifting:	return "anit-booming lifting"
		case .closed:				return "closed"
		case .closing:				return "closing"
		case .closingLifting:		return "closing lifting"
		case .intermediateLifting:	return "lifting intermediate"
		case .intermediatePosition:	return "intermediate position"
		case .intermediateSliding:	return "sliding intermediate"
		case .open:					return "open"
		case .opening:				return "opening"
		case .openingLifting:		return "opening lifting"
		case .openLifting:			return "lifting open"
		case .running:				return "running"
		}
	}
}

// MARK: - SunroofStatus

/// State for sun roof blind attribute
public enum SunroofBlindStatus: Int, Codable, CaseIterable {
    case intermediate = 0
    case opened = 1
    case closed = 2
    case opening = 3
    case closing = 4
}

extension SunroofBlindStatus {
    
    public var stateString: String {
        switch self {
        case .intermediate:         return "intermediate"
        case .opened:               return "opened"
        case .closed:               return "closed"
        case .opening:              return "opening"
        case .closing:              return "closing"
        }
    }
    
}
