//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of collision related attributes
public struct VehicleCollisionModel {
	
    /// UTC timestamp in milliseconds of last park Event
    /// Range: 0..2^64-2
	public let lastParkEvent: StatusAttributeType<Int, ClockHourUnit>
    /// Describes the confirmation state of the last park (damage) event.
	public let lastParkEventNotConfirmed: StatusAttributeType<LastParkEventState, NoUnit>
    /// Park event level
	public let parkEventLevel: StatusAttributeType<LowMediumHighState, NoUnit>
    /// Park event sensor status,
	public let parkEventSensorStatus: StatusAttributeType<ProtectionStatus, NoUnit>
    /// Park event direction
	public let parkEventType: StatusAttributeType<ParkEventType, NoUnit>
}
