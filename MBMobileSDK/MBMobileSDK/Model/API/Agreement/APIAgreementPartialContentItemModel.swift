//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

// swiftlint:disable identifier_name

struct APIAgreementPartialContentItemModel: Decodable {
	let allSubmitsHaveFailed: Bool?
	let errorCode: String?
	let userAgreementIDsOfUnsuccessfullySetApprovals: [String]?
}
