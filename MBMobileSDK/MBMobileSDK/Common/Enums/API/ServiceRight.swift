//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// The user based rights to change a service status
public enum ServiceRight: String, Codable, CaseIterable {
	case activate = "ACTIVATE"
	case deactivate = "DEACTIVATE"
	case execute = "EXECUTE"
	case manage = "MANAGE"
	case read = "READ"
}
