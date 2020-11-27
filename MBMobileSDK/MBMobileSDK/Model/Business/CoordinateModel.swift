//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of coordinates
public struct CoordinateModel: Codable, Equatable {
	
    /// Latitude
	public let latitude: Double
    /// Longitude
	public let longitude: Double
	
	
	// MARK: - Init
	
	public init(latitude: Double, longitude: Double) {
		
		self.latitude = latitude
		self.longitude = longitude
	}
}
