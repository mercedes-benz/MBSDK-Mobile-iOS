//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBNetworkKit

/// Error cases for OAuth login
public enum LoginError: Error {
    ///refresh token is a empty string
    case emptyRefreshToken
	///logout process reported without any data
	case logoutNoData
	//no enviroment
	case noEnviroment
	///user not authorized
	case notAuthorized
	///no valid jwt token
	case noValidJwtToken
	///no valid mail
	case noValidMail
	///no valid pin
	case noValidPin
	///no valid phone
	case noValidPhone
	///no valid username
	case noValidUsername
	///url could not be constructed
	case wrongUrl
}
