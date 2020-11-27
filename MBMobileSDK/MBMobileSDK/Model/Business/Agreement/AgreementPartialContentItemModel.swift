//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

// swiftlint:disable identifier_name

public struct AgreementPartialContentItemModel {
	public let allSubmitsHaveFailed: Bool?
	public let errorCode: SubmitTermsOfUseError?
	public let userAgreementIDsOfUnsuccessfullySetApprovals: [String]?
}
