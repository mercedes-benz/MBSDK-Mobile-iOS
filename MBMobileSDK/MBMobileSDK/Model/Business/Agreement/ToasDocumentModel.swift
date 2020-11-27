//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

public struct ToasDocumentModel: Codable {
    
    public let acceptanceState: AgreementAcceptanceState
    public let displayName: String
    public let documentID: String
    public let href: String
    public let version: String

    enum CodingKeys: String, CodingKey {
        case acceptanceState, displayName, href, version
        case documentID = "documentId"
    }
    
    public init(acceptanceState: AgreementAcceptanceState, displayName: String, documentID: String, href: String, version: String) {
        self.acceptanceState = acceptanceState
        self.displayName = displayName
        self.documentID = documentID
        self.href = href
        self.version = version
    }
}
