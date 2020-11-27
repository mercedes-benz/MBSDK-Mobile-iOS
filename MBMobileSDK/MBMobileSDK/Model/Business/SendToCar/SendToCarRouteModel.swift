//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of coordinates
public struct SendToCarRouteModel: Codable {
	
    /// Text of the notification
	public let notificationText: String?
	/// The optinal route name for `HuCapabilityStatic` and `HuCapabilityDynamic`
	/// (It won't be shown for `HuCapabilitySinglePOI`)
	public let routeTitle: String?
    /// Represents the HU capability which is used
	public let routeType: HuCapability
    /// List of waypoints sent to the car.
    /// The correct amount of waypoints depends on the route type.
    /// A single waypoint for singlePOI, 2-5 for staticRoute and dynamicRoute.
	public let waypoints: [SendToCarWaypointModel]

	
	// MARK: - Init
	
	public init(routeType: HuCapability, waypoints: [SendToCarWaypointModel], routeTitle: String? = nil, notificationText: String? = nil) {

		self.notificationText = notificationText
		self.routeTitle       = routeTitle
		self.routeType        = routeType
		self.waypoints        = waypoints
	}
}
