//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APISoeAgreementModel: Decodable {
    let acceptanceState: APIAgreementAcceptanceState
    let checkBoxText: String
    let checkBoxTextKey: String
    let displayName: String
    let position: Int
    let documentID: String
    var version: String?
    let isGeneralUserAgreement: Bool
    let href: String
    let titleText: String
    
    enum CodingKeys: String, CodingKey {
        case acceptanceState = "acceptanceState"
        case isGeneralUserAgreement
        case href
        case documentID = "documentId"
        case version, position, displayName, checkBoxTextKey, checkBoxText, titleText
    }
}
