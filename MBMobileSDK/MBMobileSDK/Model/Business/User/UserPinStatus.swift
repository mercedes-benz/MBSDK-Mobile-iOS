//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of user pin status
public enum UserPinStatus: String, Codable {
    
    case set = "SET"
    case notSet = "NOT_SET"
    case unknown = "UNKNOWN"
}
