//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Available backend regions
public enum EndpointRegion: String, CaseIterable {
    case ece
}


// MARK: - Extension
public extension EndpointRegion {
    
    /// Returns a displayable representation of the region
    var title: String {
        switch self {
        case .ece:   return "ECE"
        }
    }
}
