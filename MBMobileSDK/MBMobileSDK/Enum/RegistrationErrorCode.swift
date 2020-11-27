//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Error cases for registration
public enum RegistrationErrorCode: String, Codable {
	// empty codes
	case emptyFirstName = "1001"
	case emptyLastName = "1002"
	case emptyEmail = "1003"
	case emptyPassword = "1004"
	case emptyMobileNumber = "1005"
	
	// conflict codes
	case emailExists = "2003"
	case mobileNumberExists = "2004"
	case mobileNumberOrUsernameExistsError = "2005"
	
	// bad format codes
	case invalidEmailFormat = "3001"
	case passwordTooShort = "3002"
	case passwordTooLong = "3003"
	case passwordNoUppercase = "3004"
	case passwordNoLowercase = "3005"
	case passwordNoNumber = "3006"
	case passwordNoSpecial = "3007"
	case invalidMobileNumber = "3008"
	case tooLongFirstName = "3009"
	case tooLongLastName = "3010"
	case tooShortEmail = "3011"
	case tooLongEmail = "3012"
	case tooShortMobileNumber = "3013"
	case tooLongMobileNumber = "3014"

	// pre cehck codes
	case invalidCountryCode = "10001"
}
