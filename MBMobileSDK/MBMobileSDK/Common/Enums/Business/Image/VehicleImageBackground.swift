//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// The background of a vehicle image
public enum VehicleImageBackground: Int {
	case grey = 0
	case loft
	case museum
	case outdoor
	case showroom
	case sspStyle
	case sspAMGStyle
	case transparent
	case white
}


// MARK: - Extension

extension VehicleImageBackground {
	
	var parameter: String {
		switch self {
		case .grey:			return "T1"
		case .loft:			return "T12"
		case .museum:		return "T11"
		case .outdoor:		return "T10"
		case .showroom:		return "T8"
		case .sspStyle:		return "T6"
		case .sspAMGStyle:	return "T7"
		case .transparent:	return "T9"
		case .white:		return "T0"
		}
	}
}
