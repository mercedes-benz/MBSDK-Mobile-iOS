//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of gerneric unit based attribute
public struct VehicleAttributeUnitModel<T> {
	
	/// plain unit value as string (internal usage)
	internal let value: String
	
	/// generic unit type
	public let unit: T?
}


// MARK: - Extension

public extension VehicleAttributeUnitModel {
	
	/// formatted unit value based on the device locale
	var formattedValue: String {
		
		guard let rawValue = self.rawValue else {
			return self.value
		}
		
		let minimumDigits = self.value.components(separatedBy: ".").map { $0.count }.last ?? 0
		return NumberFormattingHelper.string(rawValue, minimumDigits: minimumDigits) ?? self.value
	}
	
	/// raw value as double of the unit value
	var rawValue: Double? {
		return Double(self.value)
	}
}
