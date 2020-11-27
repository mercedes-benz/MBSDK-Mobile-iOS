//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// The brand of the vehicle
public enum VehicleSegment: String, Codable {

	/// Value if the car is a standard mercedes benz or not one of the other types
	case `default` = "DEFAULT"

	/// Represents the car segment **AMG**
	case amg = "AMG"

	/// Represents the car segment of all electric cars from Daimler
	case eq = "EQ"

	/// Represents the car segment **Maybach**
	case maybach = "MAYBACH"

	/// Represents the car segment **S-Class**
	case sclass = "SCLASS"
}
