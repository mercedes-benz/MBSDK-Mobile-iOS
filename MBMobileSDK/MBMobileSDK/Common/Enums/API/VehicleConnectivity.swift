//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Connectivity type of vehicle
public enum VehicleConnectivity: String, Codable, CaseIterable {
    case adapter = "ADAPTER"
    case builtin = "BUILTIN"
    case none = "NONE"
}


// MARK: - Extension

extension VehicleConnectivity {
	
	/// Return as bool if your car is a legacy vehicle
	public var isLegacy: Bool {
		switch self {
		case .adapter:  return true
		case .builtin:  return false
		case .none:     return true
		}
	}
}
