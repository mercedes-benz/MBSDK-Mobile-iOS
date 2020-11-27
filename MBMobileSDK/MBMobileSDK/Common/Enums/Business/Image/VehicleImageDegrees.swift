//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// The degrees that the car is rotated
public enum VehicleImageDegrees: Int {
	case d0 = 0
	case d10 = 10
	case d20 = 20
	case d30 = 30
	case d40 = 40
	case d50 = 50
	case d60 = 60
	case d70 = 70
	case d80 = 80
	case d90 = 90
	case d100 = 100
	case d110 = 110
	case d120 = 120
	case d130 = 130
	case d140 = 140
	case d150 = 150
	case d160 = 160
	case d170 = 170
	case d180 = 180
	case d190 = 190
	case d200 = 200
	case d210 = 210
	case d220 = 220
	case d230 = 230
	case d240 = 240
	case d250 = 250
	case d260 = 260
	case d270 = 270
	case d280 = 280
	case d290 = 290
	case d300 = 300
	case d310 = 310
	case d320 = 320
	case d330 = 330
	case d340 = 340
	case d350 = 350
}


// MARK: - Extension

extension VehicleImageDegrees {
	
	var parameter: String {
		
		var degreesString = "\(self.rawValue)"
		for _ in degreesString.count..<3 {
			degreesString.insert("0", at: degreesString.startIndex)
		}
		
		return degreesString
	}
}
