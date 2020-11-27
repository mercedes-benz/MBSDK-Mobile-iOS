//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public struct SendToCarWaypointModel: Codable, BluetoothPoiMappable, Equatable {
	
    /// Location latitude value (required)
	public let latitude: Double
    /// Location longitude value (required)
	public let longitude: Double
    /// Waypoint title
	public let title: String?
	public let country: String?
	public let state: String?
	public let city: String?
	public let postalCode: String?
	public let street: String?
	public let houseNumber: String?
	
	
	// MARK: - Init
	
	public init(
		latitude: Double,
		longitude: Double,
		title: String? = nil,
		country: String? = nil,
		state: String? = nil,
		city: String? = nil,
		postalCode: String? = nil,
		street: String? = nil,
		houseNumber: String? = nil) {
		
		self.latitude    = latitude
		self.longitude   = longitude
		self.title       = title
		self.country     = country
		self.state       = state
		self.city        = city
		self.postalCode  = postalCode
		self.street      = street
		self.houseNumber = houseNumber
	}
}
