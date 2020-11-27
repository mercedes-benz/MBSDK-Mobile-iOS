//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// State for vehicle position error
public enum PositionErrorState: Int, Codable, CaseIterable {
    case unknown          = 0
    case serviceInactive  = 1
    case trackingInactive = 2
    case parked           = 3
    case ignitionOn       = 4
    case ok               = 5
}


// MARK: - Extension

extension PositionErrorState {
    
    public var toString: String {
        switch self {
        case .unknown:          return "unknown"
        case .serviceInactive:  return "service inactive"
        case .trackingInactive: return "tracking inactive"
        case .parked:           return "parked"
        case .ignitionOn:       return "ignition on"
        case .ok:               return "ok"
        }
    }
}
