//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of user title
public enum UserAccountIdentifier: String, Codable {
    case email = "email"
    case phone = "mobilePhoneNumber"
}
