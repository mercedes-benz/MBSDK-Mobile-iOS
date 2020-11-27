//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Star architecture of the vehicle
public enum StarArchitecture: String, Codable {
    case noStar = "NoStar"
    case star0 = "Star0"
	case star1 = "Star1"
	case star2 = "Star2"
	case star2x3 = "Star2.3"
	case star2x5 = "Star2.5"
	case star3 = "Star3"
	case unknown
}
