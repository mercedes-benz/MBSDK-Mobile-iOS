//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Current status of a given service
public enum ServiceActivationStatus: String, Codable {
	case inactive = "INACTIVE"
	case active = "ACTIVE"
	case activationPending = "ACTIVATION_PENDING"
	case deactivationPending = "DEACTIVATION_PENDING"
	case unknown = "UNKNOWN"
}


// MARK: - Extension

extension ServiceActivationStatus {
	
	var toogled: ServiceActivationStatus {
		
		switch self {
		case .active:						return .inactive
		case .inactive:						return .active
		case .activationPending,
			 .deactivationPending,
			 .unknown:						return self
		}
	}
}
