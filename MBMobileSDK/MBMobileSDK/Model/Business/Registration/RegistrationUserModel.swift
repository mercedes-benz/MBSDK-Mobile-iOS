//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of registered user
public struct RegistrationUserModel {
	
	public let countryCode: String
	public let email: String
	public let firstName: String
	public let lastName: String
	public let mobileNumber: String
	public let useEmailAsUsername: Bool
	public let userName: String
}


// MARK: - Extension

extension RegistrationUserModel {
	
	var name: String {
		return self.firstName + " " + self.lastName
	}
}
