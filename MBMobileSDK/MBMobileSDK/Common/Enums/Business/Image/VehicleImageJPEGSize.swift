//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// The resolution of vehicle jpeg image
public enum VehicleImageJPEGSize: Int {
	case size69x66
	case size70x40
	case size138x132
	case size230x131
	case size718x295
	case size740x416
	case size800x600
	case size804x350
	case size1000x295
	case size1024x576
	case size1180x430
	case size1200x900
	case size1920x1080
	case size1920x1440
}


// MARK: - Extension

extension VehicleImageJPEGSize {
	
	var parameter: String {
		switch self {
		case .size69x66:		return "25"
		case .size70x40:		return "22"
		case .size138x132:		return "31"
		case .size230x131:		return "23"
		case .size718x295:		return "101"
		case .size740x416:		return "24"
		case .size800x600:		return "34"
		case .size804x350:		return "51"
		case .size1000x295:		return "4"
		case .size1024x576:		return "30"
		case .size1180x430:		return "50"
		case .size1200x900:		return "41"
		case .size1920x1080:	return "27"
		case .size1920x1440:	return "40"
		}
	}
}
