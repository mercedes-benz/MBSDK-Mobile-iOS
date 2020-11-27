//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of zev temperature zone related attributes
public struct VehicleZEVTariffModel {
	
    /// Price level
	public let rate: Int32
    /// Time in seconds from midnight
	public let time: Int32
}
