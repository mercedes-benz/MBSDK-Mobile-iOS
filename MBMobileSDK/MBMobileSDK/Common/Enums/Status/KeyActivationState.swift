//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - KeyActivationState

/// State for key activation attribute
public enum KeyActivationState: Bool, Codable, CaseIterable {
    case allKeysActive = 1
    case allKeysInactive = 0
}

extension KeyActivationState {

    public var toString: String {
        switch self {
        case .allKeysActive:   return "active"
        case .allKeysInactive: return "inactive"
        }
    }
}
