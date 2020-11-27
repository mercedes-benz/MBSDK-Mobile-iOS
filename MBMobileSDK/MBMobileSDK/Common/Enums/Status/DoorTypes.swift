//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - DoorLockOverallStatus

/// State for door lock overall status
public enum DoorLockOverallStatus: Int, Codable, CaseIterable {
	case locked = 0
	case unlocked = 1
	case notExisting = 2
	case unknown = 3
}

extension DoorLockOverallStatus {
	
	public var toString: String {
		switch self {
		case .locked:		return "locked"
		case .notExisting:	return "not existing"
		case .unlocked:		return "unlocked"
		case .unknown:		return "unknown"
		}
	}
}


// MARK: - DoorOverallStatus

/// State for doors overall status
public enum DoorOverallStatus: Int, Codable, CaseIterable {
	case open = 0
	case closed = 1
	case notExisting = 2
	case unknown = 3
}

extension DoorOverallStatus {
	
	public var toString: String {
		switch self {
		case .closed:		return "closed"
		case .notExisting:	return "not existing"
		case .open:			return "open"
		case .unknown:		return "unknown"
		}
	}
}


// MARK: - DoorStatus

/// Bool state for closed/opened events
public enum DoorStatus: Bool, Codable, CaseIterable {
	case closed = 0
	case open = 1
}

extension DoorStatus {
	
	public var toString: String {
		switch self {
		case .closed:	return "closed"
		case .open:		return "open"
		}
	}
}
