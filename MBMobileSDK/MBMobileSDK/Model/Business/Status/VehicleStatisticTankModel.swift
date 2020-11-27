//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of statistic based fuel related attributes
public struct VehicleStatisticTankModel<T, U> {
	
	public let consumption: VehicleStatisticResetStartDoubleModel<T>
	public let distance: VehicleStatisticResetStartDoubleModel<U>
}
