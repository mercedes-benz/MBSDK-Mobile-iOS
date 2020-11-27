//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public class AgreementsModel: Codable {
    
    public var soe = [SoeAgreementModel]()
    public var ciam = [CiamAgreementModel]()
    public var custom = [CustomAgreementModel]()
    public var ldsso = [LdssoAgreementModel]()
    public var toas: ToasAgreementModel?
    public var natCon: NatConAgreementModel?
    
    enum CodingKeys: String, CodingKey {
        case soe = "SOE"
        case ciam = "CIAM"
        case custom = "CUSTOM"
        case ldsso = "LDSSO"
        case toas = "TOAS"
        case natCon = "NATCON_V1"
    }
    
    
    // MARK: - Init
    
    public init(ciam: [CiamAgreementModel],
                custom: [CustomAgreementModel],
                soe: [SoeAgreementModel],
                ldsso: [LdssoAgreementModel],
                toas: ToasAgreementModel?,
                natCon: NatConAgreementModel?) {
        
        self.ciam = ciam
        self.custom = custom
        self.soe = soe
        self.ldsso = ldsso
        self.toas = toas
        self.natCon = natCon
    }
    
}
