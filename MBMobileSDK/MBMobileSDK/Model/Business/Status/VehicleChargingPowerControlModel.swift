//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of zev charging power control related attributes
public struct VehicleChargingPowerControlModel {
	
	public let chargingStatus: Int
	public let controlDuration: Int64
    /// 0-14, Placeholder values for now.
	public let controlInfo: Int
	public let chargingPower: Int
    /// 0: Not defined
    /// 1: Service not active
    /// 2: Service active
	public let serviceStatus: Int
    /// 0: Not defined
    /// 1: Service not available
    /// 2: Service available
	public let serviceAvailable: Int
    /// 0: Undefined use case
    /// 1: Undefined use case Mercedes-Benz
    /// 2: Undefined use case third party
    /// 3: Time of use
    /// 4: Solar charging
    /// 5: Control of variable charging power based on time schedule
    /// 6: Control of variable charging and discharging power based on time schedule
    /// 7..62: Undefined
	public let useCase: Int
}
