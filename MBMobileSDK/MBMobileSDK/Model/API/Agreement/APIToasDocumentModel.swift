//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

struct APIToasDocumentModel: Codable {
    let acceptanceState: APIAgreementAcceptanceState
    let displayName: String
    let documentID: String
    let href: String
    let version: String

    enum CodingKeys: String, CodingKey {
        case acceptanceState, displayName, href, version
        case documentID = "documentId"
    }
}
