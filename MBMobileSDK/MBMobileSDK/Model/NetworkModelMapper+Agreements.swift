//
//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

extension NetworkModelMapper {

	static func map(apiAgreementsModel: APIAgreementsPartialContentModel) -> AgreementsPartialContentModel {
		return AgreementsPartialContentModel(ciamLegalTextsAcceptanceState: self.map(apiAgreementsModel.ciamLegalTextsAcceptanceState),
											 customLegalTextsAcceptanceState: self.map(apiAgreementsModel.customLegalTextsAcceptanceState),
											 ldssoLegalTextsAcceptanceState: self.map(apiAgreementsModel.ldssoLegalTextsAcceptanceState),
											 natconLegalTextsAcceptanceState: self.map(apiAgreementsModel.natconLegalTextsAcceptanceState),
                                             soeLegalTextsAcceptanceState: self.map(apiAgreementsModel.soeLegalTextsAcceptanceState),
                                             toasLegalTextAcceptanceState: self.map(apiAgreementsModel.toasLegalTextsAcceptanceState))
	}
	
	
	// MARK: - Helper
	
	private static func map(_ apiModel: APIAgreementPartialContentItemModel?) -> AgreementPartialContentItemModel? {
		
		guard let apiModel = apiModel else {
			return nil
		}
		return AgreementPartialContentItemModel(allSubmitsHaveFailed: apiModel.allSubmitsHaveFailed,
												errorCode: SubmitTermsOfUseError(rawValue: apiModel.errorCode ?? ""),
												userAgreementIDsOfUnsuccessfullySetApprovals: apiModel.userAgreementIDsOfUnsuccessfullySetApprovals)
	}
}
