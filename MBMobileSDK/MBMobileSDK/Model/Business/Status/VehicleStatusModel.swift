//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBRealmKit

/// Representation of vehicle status related attributes
public struct VehicleStatusModel {
	
    /// Auxiliary heating status
	public let auxheat: VehicleAuxheatModel
    /// Doors status
	public let doors: VehicleDoorsModel
    /// Driving mode
    public let drivingMode: VehicleDrivingModeModel
    /// Eco-score status
	public let ecoScore: VehicleEcoScoreModel
    /// Engine status
	public let engine: VehicleEngineModel
    /// Attribute change as unix timestamp in milliseconds with UTC timezone
    public let eventTimestamp: Int64
    /// Vehicle identification number
	public let finOrVin: String
    /// HeadUnit status
	public let hu: VehicleHuModel
    /// Vehicle's location
	public let location: VehicleLocationModel
    /// Journey related vehicle statistics
	public let statistics: VehicleStatisticsModel
    /// Tank status
	public let tank: VehicleTankModel
    /// Theft alarm status
	public let theft: VehicleTheftModel
    /// Tire status
	public let tires: VehicleTiresModel
    /// Miscellaneous vehicle status details
	public let vehicle: VehicleVehicleModel
    /// Current vehicle warnings
	public let warnings: VehicleWarningsModel
    /// Windows status
	public let windows: VehicleWindowsModel
    /// Zero emission vehicle status
	public let zev: VehicleZEVModel
}


// MARK: - Entity

extension VehicleStatusModel: Entity {
	
	public var id: String {
		return self.finOrVin
	}
}
