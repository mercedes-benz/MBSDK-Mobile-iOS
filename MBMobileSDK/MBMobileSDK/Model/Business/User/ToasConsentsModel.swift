//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

public struct ToasConsentsModel: Codable {
    
    public let version: String
    public let documentID: String
    public let acceptanceState: Bool
    public let acceptedLocale: String

    enum CodingKeys: String, CodingKey {
        case documentID = "documentId"
        case version, acceptanceState, acceptedLocale
    }
    
    public init(version: String, documentID: String, acceptanceState: Bool, acceptedLocale: String) {
        self.version = version
        self.documentID = documentID
        self.acceptanceState = acceptanceState
        self.acceptedLocale = acceptedLocale
    }
}
