//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation all kind of windows
public struct VehicleWindowsModel {
	
    /// Rear roller blind state
	public let blindRear: StatusAttributeType<WindowBlindStatus, NoUnit>
    /// Rear passenger compartment side roller blind left state
	public let blindRearLeft: StatusAttributeType<WindowBlindStatus, NoUnit>
    /// Rear passenger compartment side roller blind right state
	public let blindRearRight: StatusAttributeType<WindowBlindStatus, NoUnit>
    /// Flipper window rotary latch state
	public let flipWindowStatus: StatusAttributeType<OpenCloseState, NoUnit>
    /// Open state for front left window
	public let frontLeft: StatusAttributeType<WindowStatus, NoUnit>
    /// Open state for front right window
	public let frontRight: StatusAttributeType<WindowStatus, NoUnit>
    /// Overall open state for all windows combined
	public let overallState: StatusAttributeType<WindowsOverallStatus, NoUnit>
    /// Open state for rear left window
	public let rearLeft: StatusAttributeType<WindowStatus, NoUnit>
    /// Open state for rear right window
	public let rearRight: StatusAttributeType<WindowStatus, NoUnit>
    /// Open state for sunroof
	public let sunroof: VehicleSunroofModel
}
