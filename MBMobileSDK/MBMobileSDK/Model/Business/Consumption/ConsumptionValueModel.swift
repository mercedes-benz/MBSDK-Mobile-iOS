//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of a consumption value
public struct ConsumptionValueModel {
	
	public let consumption: Double
	public let group: Int
	public let percentage: Double
	public let unit: ConsumptionUnit
}
