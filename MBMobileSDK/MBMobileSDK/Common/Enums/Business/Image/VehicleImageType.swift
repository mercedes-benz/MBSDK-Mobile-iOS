//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// The resolution type of vehicle image
public enum VehicleImageType {
	case jpeg(size: VehicleImageJPEGSize)
	case png(size: VehicleImagePNGSize)
}


// MARK: - Extension

extension VehicleImageType {
	
	var parameter: String {
		switch self {
		case .jpeg(let size):	return "A" + size.parameter
		case .png(let size):	return "P" + size.parameter
		}
	}
}
