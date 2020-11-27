//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// State for pressure unit
public enum PressureUnit: Int, Codable, CaseIterable {
	
	/// Kilopascal
	case kpa = 1
	case bar = 2
	
	/// Pounds per square inch
	case psi = 3
}
