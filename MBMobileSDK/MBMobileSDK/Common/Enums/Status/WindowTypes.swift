//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - WindowsOverallStatus

/// State for window attribute
public enum WindowsOverallStatus: Int, Codable, CaseIterable {
	case open = 0
	case closed = 1
	case completelyOpen = 2
	case airing = 3
	case running = 4
}

extension WindowsOverallStatus {
	
	public var stateString: String {
		switch self {
		case .airing:			return "airing"
		case .closed:			return "closed"
		case .completelyOpen:	return "completely open"
		case .open:				return "open"
		case .running:			return "running"
		}
	}
}


// MARK: - WindowStatus

/// State for window attribute
public enum WindowStatus: Int, Codable, CaseIterable {
	case intermediate = 0
	case open = 1
	case closed = 2
	case airingPosition = 3
	case airingIntermediate = 4
	case running = 5
}

extension WindowStatus {
	
	public var stateString: String {
		switch self {
		case .airingIntermediate:	return "airing intermediate"
		case .airingPosition:		return "airing position"
		case .closed:				return "closed"
		case .intermediate:			return "intermediate"
		case .open:					return "open"
		case .running:				return "running"
		}
	}
}

// MARK: - WindowBlindStatus

/// State for window blind attribute
public enum WindowBlindStatus: Int, Codable, CaseIterable {
    case intermediate = 0
    case opened = 1
    case closed = 2
}

extension WindowBlindStatus {
    
    public var stateString: String {
        switch self {
        case .intermediate:     return "intermediate"
        case .opened:           return "opened"
        case .closed:           return "closed"
        }
    }
    
}
