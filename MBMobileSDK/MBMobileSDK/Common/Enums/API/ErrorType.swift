//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Error type
public enum ErrorType: String, Codable {
	case invalidCharacter = "InvalidCharacter"
	case invalidValue = "InvalidValue"
	case fieldNotSetable = "FieldNotSettable"
	case fieldRequired = "FieldRequired"
	case fieldTooBig = "FieldTooBig"
	case fieldTooLong = "FieldTooLong"
	case fieldTooShort = "FieldTooShort"
}
