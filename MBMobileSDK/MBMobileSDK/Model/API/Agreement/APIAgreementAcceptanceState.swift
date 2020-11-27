//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of user pin status
public enum APIAgreementAcceptanceState: String, Codable {
    case accepted    = "ACCEPTED"
    case rejected    = "REJECTED"
    case unseen      = "UNSEEN_VIA_RISINGSTARS"
}
