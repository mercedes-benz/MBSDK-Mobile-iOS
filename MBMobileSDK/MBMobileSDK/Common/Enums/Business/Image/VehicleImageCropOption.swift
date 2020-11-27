//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// The option to crop a vehicle image from BDD
public enum VehicleImageCropOption {
	// Crops without square constraint resulting in a maximum cut away area.
	case bestEffort
	// No cropping effect.
	case none
	// Picture cropping to square. Might return a non-square image if the base image can't be cut into a square.
	case square
	// Picture cropping to square. Adds transparent pixels to base image if necessary to ensure a square image.
	case squareSafe
}


// MARK: - Extension

extension VehicleImageCropOption {
	
	var parameter: String {
		switch self {
		case .bestEffort:	return "-croppedBestEffort"
		case .none:			return ""
		case .square:		return "-croppedSquare"
		case .squareSafe:	return "-croppedSafeSquare"
		}
	}
}
