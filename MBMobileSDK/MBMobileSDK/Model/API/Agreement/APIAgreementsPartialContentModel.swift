//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

struct APIAgreementsPartialContentModel: Decodable {
	let ciamLegalTextsAcceptanceState: APIAgreementPartialContentItemModel?
	let customLegalTextsAcceptanceState: APIAgreementPartialContentItemModel?
	let ldssoLegalTextsAcceptanceState: APIAgreementPartialContentItemModel?
	let natconLegalTextsAcceptanceState: APIAgreementPartialContentItemModel?
	let soeLegalTextsAcceptanceState: APIAgreementPartialContentItemModel?
    let toasLegalTextsAcceptanceState: APIAgreementPartialContentItemModel?
	
	enum CodingKeys: String, CodingKey {
        case ciamLegalTextsAcceptanceState = "unsuccesfullySetCIAMLegalTextsAcceptanceState"
        case customLegalTextsAcceptanceState = "unsuccesfullySetCUSTOMLegalTextsAcceptanceState"
        case ldssoLegalTextsAcceptanceState = "unsuccesfullySetLDSSOLegalTextsAcceptanceState"
        case natconLegalTextsAcceptanceState = "unsuccesfullySetNATCONLegalTextsAcceptanceState"
        case soeLegalTextsAcceptanceState = "unsuccesfullySetSOELegalTextsAcceptanceState"
        case toasLegalTextsAcceptanceState = "unsuccesfullySetToasLegalTextsAcceptanceState"
    }
}
