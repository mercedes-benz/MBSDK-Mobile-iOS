//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Doors count of the vehicle
public enum DoorsCount: String, Codable, CaseIterable {
	case four = "FourDoors"
	case none = "NoDoors"
	case three = "ThreeDoors"
	case two = "TwoDoors"
}
