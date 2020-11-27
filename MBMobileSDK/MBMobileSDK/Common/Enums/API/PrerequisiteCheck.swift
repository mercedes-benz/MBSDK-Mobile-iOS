//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// The prerequisites of a vehicle service
public enum PrerequisiteCheck: String, Codable {
	case consent
	case contractualAvailability
	case fuseBox
	case license
	case requiredFields
	case technicalAvailability
	case trustlevel
	case userAgreement
}
