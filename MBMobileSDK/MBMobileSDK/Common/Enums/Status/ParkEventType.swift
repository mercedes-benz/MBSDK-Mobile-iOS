//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// State for park event attribute
public enum ParkEventType: Int, Codable, CaseIterable {
	case idle = 0
	case frontLeft = 1
	case frontMiddle = 2
	case frontRight = 3
	case right = 4
	case rearRight = 5
	case rearMiddle = 6
	case rearLeft = 7
	case left = 8
	case directionUnknown = 9
}


// MARK: - Extension

extension ParkEventType {
	
	public var toString: String {
		switch self {
		case .directionUnknown:	return "direction unknown"
		case .frontLeft:		return "front left"
		case .frontMiddle:		return "front middle"
		case .frontRight:		return "front right"
		case .idle:				return "idle"
		case .left:				return "left"
		case .rearRight:		return "rear right"
		case .rearMiddle:		return "rear middle"
		case .rearLeft:			return "rear left"
		case .right:			return "right"
		}
	}
}
