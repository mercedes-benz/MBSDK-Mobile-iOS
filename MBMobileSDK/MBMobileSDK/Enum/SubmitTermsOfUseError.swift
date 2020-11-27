//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

/// Error cases of submitting the terms of use
public enum SubmitTermsOfUseError: String, CaseIterable, Error {
	case noError = "NO_ERROR"
	case badRequest = "BAD_REQUEST"
	case internalError = "INTERNAL_ERROR"
	case databaseError = "DATABASE_ERROR"
	case userNotFound = "USER_NOT_FOUND_ERROR"
	case documentNotFound = "DOCUMENT_NOT_FOUND_ERROR"
	case badGateway = "BAD_GATEWAY_ERROR"
	case userAgreementNotFound = "USER_AGREEMENT_NOT_FOUND_ERROR"
	case unsupportedCountry = "UNSUPPORTED_COUNTRY_ERROR"
	case invalidLocale = "INVALID_LOCALE_ERROR"
	case invalidCountry = "INVALID_COUNTRY_ERROR"
	case inconsitentAgreement = "INCONSISTENT_AGREEMENT_STATUS"
	case partialFail = "PARTIAL_FAIL"
	case outdatedDocument = "OUTDATED_DOCUMENT"
	case unsuccessfullySetLegalTextApprovals = "UNSUCCESSFULLY_SET_LEGAL_TEXT_APPROVALS"
	case mandatoryTermsNotSet = "MANDATORY_TERMS_NOT_SET_ERROR"
}
