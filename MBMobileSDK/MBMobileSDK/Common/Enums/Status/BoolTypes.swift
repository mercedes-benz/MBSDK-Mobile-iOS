//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - ActiveState

/// Bool state for active/inactive events
public enum ActiveState: Bool, Codable, CaseIterable {
	case inactive = 0
	case active = 1
}

extension ActiveState {
	
	public var toString: String {
		switch self {
		case .active:	return "active"
		case .inactive:	return "inactive"
		}
	}
}


// MARK: - ArmedState

/// Bool state for theft attribute
public enum ArmedState: Bool, Codable, CaseIterable {
	case inactive = 0
	case active = 1
}

extension ArmedState {
	
	public var toString: String {
		switch self {
		case .active:	return "armed"
		case .inactive:	return "not armed"
		}
	}
}


// MARK: - DisableState

/// Bool state for disabled attributes
public enum DisableState: Bool, Codable, CaseIterable {
	case notDisabled = 0
	case disabled = 1
}

extension DisableState {
	
	public var toString: String {
		switch self {
		case .disabled:		return "disabled"
		case .notDisabled:	return "not disabled"
		}
	}
}


// MARK: - LastParkEventState

public enum LastParkEventState: Bool, Codable, CaseIterable {
	case popupConfirmed = 0
	case popupNotConfirmed = 1
}

extension LastParkEventState {
	
	public var toString: String {
		switch self {
		case .popupConfirmed:		return "confirmed"
		case .popupNotConfirmed:	return "not confirmed"
		}
	}
}


// MARK: - OnOffState

/// Bool state for on-off-attributes
public enum OnOffState: Bool, Codable, CaseIterable {
	case off = 0
	case on = 1
}

extension OnOffState {
	
	public var toString: String {
		switch self {
		case .off:	return "off"
		case .on:	return "on"
		}
	}
}


// MARK: - OpenCloseState

/// Bool state for open-closed-attributes
public enum OpenCloseState: Bool, Codable, CaseIterable {
	case closed = 0
	case open = 1
}

extension OpenCloseState {
	
	public var toString: String {
		switch self {
		case .closed:	return "closed"
		case .open:		return "open"
		}
	}
}
