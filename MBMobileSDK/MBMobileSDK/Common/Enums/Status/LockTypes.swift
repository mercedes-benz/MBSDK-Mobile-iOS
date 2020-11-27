//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - LockStatus

/// Bool state for locked/unlocked events
public enum LockStatus: Bool, Codable, CaseIterable {
	case locked = 0
	case unlocked = 1
}

extension LockStatus {
	
	public var toString: String {
		switch self {
		case .locked:	return "locked"
		case .unlocked:	return "unlocked"
		}
	}
}


// MARK: - VehicleLockStatus

/// State for vehicle lock attribute
public enum VehicleLockStatus: Int, Codable, CaseIterable {
	case unlocked = 0
	case lockedInternal = 1
	case lockedExternal = 2
	case unlockedSelective = 3
	case unknown = 4
}

extension VehicleLockStatus {
	
	public var toString: String {
		switch self {
		case .lockedExternal:		return "locked ext"
		case .lockedInternal:		return "locked int"
		case .unlocked:				return "unlocked"
		case .unlockedSelective:	return "unlocked sel"
		case .unknown:				return "unknown"
		}
	}
}
