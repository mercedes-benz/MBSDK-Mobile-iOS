//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - TemperatureType

/// State for temperature unit attribute
public enum TemperatureType: Bool, Codable, CaseIterable {
	case celsius = 0
	case fahrenheit = 1
}

extension TemperatureType {
	
	public var toString: String {
		switch self {
		case .celsius:		return "celsius"
		case .fahrenheit:	return "fahrenheit"
		}
	}
}


// MARK: - TemperatureZone

/// State for temperature zone
public enum TemperatureZone: String, CaseIterable {
	case frontCenter
	case frontLeft
	case frontRight
	case rear2center
	case rear2left
	case rear2right
	case rearCenter
	case rearLeft
	case rearRight
}

extension TemperatureZone {
	
	public var toString: String {
		switch self {
		case .frontCenter:	return "front center"
		case .frontLeft:	return "front left"
		case .frontRight:	return "front right"
		case .rear2center:	return "rear center 2"
		case .rear2left:	return "rear left 2"
		case .rear2right:	return "rear right 2"
		case .rearCenter:	return "rear center"
		case .rearLeft:		return "rear left"
		case .rearRight:	return "rear right"
		}
	}
}
