//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Available backend stages
public enum EndpointStage: String, CaseIterable {
    case mock
    case prod
}


// MARK: - Extension

public extension EndpointStage {

    /// Returns a displayable string of the stage
    var title: String {
        switch self {
        case .mock:     return "Mock"
        case .prod:     return "Prod"
        }
    }
}
