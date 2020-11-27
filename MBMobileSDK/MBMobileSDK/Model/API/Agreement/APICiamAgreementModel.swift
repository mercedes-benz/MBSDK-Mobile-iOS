//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APICiamAgreementModel: Decodable {
    let acceptanceState: APIAgreementAcceptanceState
    let documentID: String
    var version: String?
    let href: String
    
    enum CodingKeys: String, CodingKey {
        case acceptanceState
        case href
        case documentID = "documentId"
        case version
    }
}
