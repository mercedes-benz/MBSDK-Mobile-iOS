//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of the consumption data
public struct ConsumptionDataModel {
	
	public let changed: Bool
	public let value: [ConsumptionValueModel]
}
