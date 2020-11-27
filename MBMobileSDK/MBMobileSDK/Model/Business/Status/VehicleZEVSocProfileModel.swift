//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of zev state of charge profile related attributes
public struct VehicleZEVSocProfileModel {
	
    /// State of Charge
    /// Range: 0..100
	public let soc: Int32
    /// Timestamp in seconds, UTC
	public let time: Int64
}
