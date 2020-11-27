//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of profile field validation information
public struct ProfileFieldValidationModel: Codable {
    public var minLength, maxLength: Int?
    public var regularExpression: String?
}
