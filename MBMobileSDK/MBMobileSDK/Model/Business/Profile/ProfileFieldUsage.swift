//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of profile field usage
public enum ProfileFieldUsage: String, Codable {
    case optional   = "OPTIONAL"
    case mandatory  = "MANDATORY"
    case invisible  = "INVISIBLE"
    case readOnly   = "READONLY"
}
