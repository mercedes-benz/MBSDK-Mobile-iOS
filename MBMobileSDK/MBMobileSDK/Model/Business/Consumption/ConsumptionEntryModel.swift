//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of a consumption entry
public struct ConsumptionEntryModel {
    
    /// Value changed
	public let changed: Bool
    /// Consumption unit
	public let unit: ConsumptionUnit
    /// Consumption level
	public let value: Double
}
