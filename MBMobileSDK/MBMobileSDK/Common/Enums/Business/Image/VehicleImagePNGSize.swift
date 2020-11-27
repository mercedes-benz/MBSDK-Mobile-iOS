//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// The resolution of vehicle png image
public enum VehicleImagePNGSize: Int {
	case size71x71
	case size142x142
	case size272x153
	case size590x332
	case size696x392
	case size710x710
	case size804x350
	case size1000x295
	case size1180x430
	case size1920x1080
	case size1600x900
}


// MARK: - Extension

extension VehicleImagePNGSize {
	
	var parameter: String {
		switch self {
		case .size71x71:		return "26"
		case .size142x142:		return "29"
		case .size272x153:		return "36"
		case .size590x332:		return "37"
		case .size696x392:		return "38"
		case .size710x710:		return "35"
		case .size804x350:		return "51"
		case .size1000x295:		return "4"
		case .size1180x430:		return "50"
		case .size1920x1080:	return "27"
		case .size1600x900:		return "39"
		}
	}
}
