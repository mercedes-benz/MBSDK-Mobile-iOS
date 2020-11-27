//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

public struct UserVerificationConfirmationModel: Codable {
    let code: String
    let type: VerificationType
    let subject: String
    
    public init(code: String, type: VerificationType, subject: String) {
        self.code = code
        self.type = type
        self.subject = subject
    }
}
