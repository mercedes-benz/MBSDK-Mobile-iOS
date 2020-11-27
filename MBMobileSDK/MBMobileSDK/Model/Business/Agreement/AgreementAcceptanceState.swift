//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of agreement acceptance state
public enum AgreementAcceptanceState: String, Codable {
    case accepted    = "ACCEPTED"
    case rejected    = "REJECTED"
    case unseen      = "UNSEEN_VIA_RISINGSTARS"
}
