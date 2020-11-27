//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APILdssoAgreementModel: Decodable {
    public let documentID: String
    public let locale: String
    public let version: String
    public let position: Int
    public let displayName: String
    public let implicitConsent: Bool
    public let href: String
    public let acceptanceState: APIAgreementAcceptanceState
    
    enum CodingKeys: String, CodingKey {
        case documentID = "id"
        case locale
        case version
        case position
        case displayName
        case implicitConsent
        case href
        case acceptanceState = "acceptanceState"
    }
}
