//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public struct AgreementsSubmitModel: Codable {
    
    public var customLegalTexts: [AgreementSubmitModel]
    public var natconLegalTexts: [AgreementSubmitModel]
    public var soeLegalTexts: [AgreementSubmitModel]
    public var ciamLegalTexts: [AgreementSubmitModel]
    public var ldssoLegalTexts: [AgreementSubmitModel]
    public var toasLegalTexts: [AgreementSubmitModel]
    public var isEmpty: Bool {
        return customLegalTexts.isEmpty &&
            natconLegalTexts.isEmpty &&
            soeLegalTexts.isEmpty &&
            ciamLegalTexts.isEmpty &&
            ldssoLegalTexts.isEmpty &&
        toasLegalTexts.isEmpty
    }
    
    // MARK: - Init
    
    public init(customLegalTexts: [AgreementSubmitModel] = [],
                natconLegalTexts: [AgreementSubmitModel] = [],
                soeLegalTexts: [AgreementSubmitModel] = [],
                ciamLegalTexts: [AgreementSubmitModel] = [],
                ldssoLegalTexts: [AgreementSubmitModel] = [],
                toasLegalTexts: [AgreementSubmitModel] = []) {
        
        self.customLegalTexts = customLegalTexts
        self.natconLegalTexts = natconLegalTexts
        self.soeLegalTexts = soeLegalTexts
        self.ciamLegalTexts = ciamLegalTexts
        self.ldssoLegalTexts = ldssoLegalTexts
        self.toasLegalTexts = toasLegalTexts
    }
}
