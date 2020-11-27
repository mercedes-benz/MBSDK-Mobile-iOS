//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Roof type of the vehicle
public enum RoofType: String, Codable, CaseIterable {
	case convertible = "Convertible"
	case none = "NoSunroof"
	case panorama = "PanoramaSunroof"
	case small = "SmallSunroof"
}
