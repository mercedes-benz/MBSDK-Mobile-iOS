//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public struct AgreementSubmitModel: Codable {
    
    public let documentId: String
    public let version: String
    public let acceptanceState: Bool
    public let acceptedLocale: String
    
    
    // MARK: - Init
    
    public init(documentId: String, version: String, acceptanceState: Bool, acceptedLocale: String) {
        
        self.documentId = documentId
        self.version = version
        self.acceptanceState = acceptanceState
        self.acceptedLocale = acceptedLocale
    }
}
