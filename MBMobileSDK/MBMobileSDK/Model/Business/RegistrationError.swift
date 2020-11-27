//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import MBNetworkKit

// MARK: - RegistrationError

public struct RegistrationError: Error {
	
	/// Localized error message
	public let description: String?
	
	public let errors: [RegistrationFieldError]
}


// MARK: - RegistrationFieldError

public struct RegistrationFieldError {
	
	public let description: String
	public let fieldName: String?
}
