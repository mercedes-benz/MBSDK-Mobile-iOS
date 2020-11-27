//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APICustomAgreementModel: Decodable {
    let acceptanceState: APIAgreementAcceptanceState
    let displayLocation: String
    let displayName: String
    let position: Int
    let documentID: String
    let href: String
    let version: Int

    enum CodingKeys: String, CodingKey {
        case acceptanceState = "acceptanceState"
        case position
        case href
        case documentID = "id"
        case displayLocation, displayName, version
    }
}
