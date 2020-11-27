//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of vehicle image request
public struct VehicleImageRequest {
	
	public let background: VehicleImageBackground
	public let centered: Bool
	public let cropOption: VehicleImageCropOption
	public let degrees: VehicleImageDegrees
	public let fallbackImage: Bool
	public let night: Bool
	public let roofOpen: Bool
	public let shouldBeCached: Bool
	public let size: VehicleImageType
	
	
	// MARK: - Init
	
	public init(
		background: VehicleImageBackground,
		centered: Bool,
		cropOption: VehicleImageCropOption = .none,
		degrees: VehicleImageDegrees,
		fallbackImage: Bool = false,
		night: Bool,
		roofOpen: Bool,
		shouldBeCached: Bool,
		size: VehicleImageType) {
		
		self.background     = background
		self.centered       = centered
		self.cropOption     = cropOption
		self.degrees        = degrees
		self.fallbackImage  = fallbackImage
		self.night          = night
		self.roofOpen       = roofOpen
		self.shouldBeCached = shouldBeCached
		self.size           = size
	}
}
