//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - StatusType

/// Attribute status type
public enum StatusType: Int32 {
	case invalid = 3
	case notAvailable = 4
	case noValue = 1
	case valid = 0
}


// MARK: - StatusAttributeType

/// StatusAttributeType with generic value
public enum StatusAttributeType<T, U> {
	
	/// invalid attribute data with the timestamp of last attribute change in milliseconds
	case invalid(timestamp: Int64)
	/// not available with the timestamp of last attribute change in milliseconds
	case notAvailable(timestamp: Int64)
	/// no value available with the timestamp of last attribute change in milliseconds
	case noValue(timestamp: Int64)
	/// valid generic attribute data with the timestamp of last attribute change in milliseconds
	case valid(value: T?, timestamp: Int64, unit: VehicleAttributeUnitModel<U>?)
}

public extension StatusAttributeType {
	
	/// The date of the last attribute change.
	var date: Date? {
		
		guard let timestamp = self.timestamp else {
			return nil
		}
		
		return Date(timeIntervalSince1970: TimeInterval(timestamp))
	}
	
	/// The raw value of StatusAttributeType of the last attribute change.
	var status: Int32 {
		switch self {
		case .invalid:	    return StatusType.invalid.rawValue
		case .notAvailable: return StatusType.notAvailable.rawValue
		case .noValue:	    return StatusType.noValue.rawValue
		case .valid:	    return StatusType.valid.rawValue
		}
	}
	
	/// The timestamp of the last attribute change in seconds since beginning of unix time.
	var timestamp: Int64? {
		switch self {
		case .invalid(let timestamp):		return timestamp
		case .notAvailable(let timestamp):	return timestamp
		case .noValue(let timestamp):		return timestamp
		case .valid(_, let timestamp, _):	return timestamp
		}
	}

	/// The unit of the last attribute.
	var unit: VehicleAttributeUnitModel<U>? {
		switch self {
		case .invalid:					return nil
		case .notAvailable:				return nil
		case .noValue:					return nil
		case .valid(_, _, let unit):	return unit
		}
	}
	
	/// The generic valid value of the last attribute change.
	var value: T? {
		switch self {
		case .invalid:					return nil
		case .notAvailable:				return nil
		case .noValue:					return nil
		case .valid(let value, _, _):	return value
		}
	}
}
