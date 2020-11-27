//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public enum SendToCarCapability: String, CaseIterable, Codable, CustomStringConvertible {

    /// Ability to send a single POI via Bluetooth
    case singlePoiBluetooth = "SINGLE_POI_BLUETOOTH"
    /// Ability to send a single POI via Backend
    case singlePoiBackend = "SINGLE_POI_BACKEND"
    /// Ability to send a static route to Backend
    case staticRouteBackend = "STATIC_ROUTE_BACKEND"
    /// Ability to send a dynamic route to Backend
    case dynamicRouteBackend = "DYNAMIC_ROUTE_BACKEND"
}

extension SendToCarCapability {
	
    public var description: String {
        switch self {
        case .singlePoiBluetooth:  return "Single poi via bluetooth"
        case .singlePoiBackend:    return "Single poi via backend"
        case .staticRouteBackend:  return "Route via backend"
        case .dynamicRouteBackend: return "Route via backend"
        }
    }
}
