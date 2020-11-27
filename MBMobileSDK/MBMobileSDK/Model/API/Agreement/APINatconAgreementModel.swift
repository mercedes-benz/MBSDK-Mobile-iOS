//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APINatConAgreementModel: Decodable {
    
    let acceptAllText: String?
    let title: String
    let description: String
    let version: String?
    let documents: [APINatConAgreementDocumentModel]
    
    enum CodingKeys: String, CodingKey {
        case acceptAllText
        case title
        case description
        case version
        case documents
    }
    
}


struct APINatConAgreementDocumentModel: Decodable {
    
    let isMandatory: Bool
    let position: Int
    let termsId: String
    let text: String
    let href: String
    let language: String
    let acceptanceState: APIAgreementAcceptanceState?
    
    enum CodingKeys: String, CodingKey {
        case isMandatory
        case position
        case termsId
        case text
        case href
        case language
        case acceptanceState
    }
    
}
