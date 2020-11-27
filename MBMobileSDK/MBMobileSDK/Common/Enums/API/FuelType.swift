//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Fuel type of the vehicle
public enum FuelType: String, Codable, CaseIterable {
	case combustion = "Combustion"
	case electric = "Electric"
	case fuelCellPlugin = "FuelCellPlugin"
	case gas = "Gas"
	case hybrid = "Hybrid"
	case plugin = "Plugin"
}
