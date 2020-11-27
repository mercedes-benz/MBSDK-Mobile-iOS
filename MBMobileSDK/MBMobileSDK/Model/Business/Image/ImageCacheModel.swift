//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of image cache
public struct ImageCacheModel {
	
	public let background: VehicleImageBackground
	public let degrees: Int
	public let imageData: Data?
	public let imageType: VehicleImageType
	
	
	// MARK: - Init
	
	public init(background: VehicleImageBackground, degrees: Int, imageData: Data?, imageType: VehicleImageType) {
		
		self.background = background
		self.degrees    = degrees
		self.imageData  = imageData
		self.imageType  = imageType
	}
}
