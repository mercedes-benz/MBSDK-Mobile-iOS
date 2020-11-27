//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of sunroof related attributes
public struct VehicleSunroofModel {
	
    /// Front roller blind state sunroof
	public let blindFront: StatusAttributeType<SunroofBlindStatus, NoUnit>
    /// Rear roller blind state sunroof
	public let blindRear: StatusAttributeType<SunroofBlindStatus, NoUnit>
    /// Event Info Rainclose, e.g. rain lift position
	public let event: StatusAttributeType<SunroofEventState, NoUnit>
    /// Rainclose monitoring active state
	public let isEventActive: StatusAttributeType<ActiveState, NoUnit>
    /// Sliding roof opened / closed state
	public let status: StatusAttributeType<SunroofStatus, NoUnit>
}
