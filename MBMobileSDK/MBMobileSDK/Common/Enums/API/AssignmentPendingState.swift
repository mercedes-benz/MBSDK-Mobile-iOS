//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Pending state of vehicle assignment
public enum AssignmentPendingState: String, Codable {
	case assigning
	case deleting
}
