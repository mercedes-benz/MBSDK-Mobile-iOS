//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - EngineState

/// State for engine state status
public enum EngineState: Bool, Codable, CaseIterable {
	case stopped = 0
	case running = 1
}

// MARK: - Extension

extension EngineState {
	
	public var toString: String {
		switch self {
		case .running:	return "running"
		case .stopped:	return "stopped"
		}
	}
}


// MARK: - IgnitionState

/// State for ignition attribute
public enum IgnitionState: Int, Codable, CaseIterable {
	case lock = 0
	case off = 1
	case accessory = 2
	case on = 4
	case start = 5
}


// MARK: - Extension

extension IgnitionState {
	
	public var toString: String {
		switch self {
		case .accessory:	return "accessory"
		case .lock:			return "lock"
		case .off:			return "off"
		case .on:			return "on"
		case .start:		return "start"
		}
	}
}


// MARK: - RemoteStartState

/// State for remote start active status
public enum RemoteStartActiveState: Bool, Codable, CaseIterable {
	case inactive = 0
	case active = 1
}

// MARK: - Extension

extension RemoteStartActiveState {
	
	public var toString: String {
		switch self {
		case .active:	return "active"
		case .inactive:	return "inactive"
		}
	}
}
