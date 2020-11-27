//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Tire pressure monitoring type of the vehicle
public enum TirePressureMonitoringType: String, Codable, CaseIterable {
	case flat = "FlatRunner"
	case monitoring = "TirePressureMonitoring"
	case none = "NoTirePressure"
}
