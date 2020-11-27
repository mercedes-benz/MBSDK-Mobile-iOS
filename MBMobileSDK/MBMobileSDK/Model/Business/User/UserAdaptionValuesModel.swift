//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of user preferred units
public struct UserAdaptionValuesModel: Equatable {
    
    public let bodyHeight: Int?
    public let preAdjustment: Bool?
    public let alias: String?

    // MARK: - Init
    
    public init(bodyHeight: Int?, preAdjustment: Bool?, alias: String?) {
        self.bodyHeight     = bodyHeight
        self.preAdjustment  = preAdjustment
        self.alias          = alias
    }
}
