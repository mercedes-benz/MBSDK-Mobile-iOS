//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

public struct UserVerificationTransactionModel: Codable {
    let type: VerificationType
    let subject: String
    
    public init(type: VerificationType, subject: String) {
        self.type = type
        self.subject = subject
    }
    
}
