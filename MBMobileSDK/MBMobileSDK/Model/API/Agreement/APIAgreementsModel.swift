//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIAgreementsModel: Decodable {
    
    let ciam: [APICiamAgreementModel]?
    let custom: [APICustomAgreementModel]?
    let errors: [APIAgreementsErrorModel]?
    let ldsso: [APILdssoAgreementModel]?
    let soe: [APISoeAgreementModel]?
    let toas: APIToasAgreementModel?
    let natCon: APINatConAgreementModel?
    
    enum CodingKeys: String, CodingKey {
        case ciam = "CIAM"
        case custom = "CUSTOM"
        case errors = "Errors"
        case ldsso = "LDSSO"
        case soe = "SOE"
        case toas = "TOAS"
        case natCon = "NATCON_V1"
    }
    
}
