//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of generic status attribute
public struct VehicleStatusAttributeModel<T, U> {
	
	public let status: Int32
	public let timestampInMs: Int64
	public let unit: VehicleAttributeUnitModel<U>?
	public let value: T?
}
