//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// State for tire pressure unit
public enum TirePressureUnit: String, Codable {
	case bar = "Bar"
	case kilopascal = "kPa"
	case poundsPerSquareInch = "Psi"
}


// MARK: - Extension

extension TirePressureUnit {
	
	public static var defaultCase: TirePressureUnit {
		return .kilopascal
	}
}
