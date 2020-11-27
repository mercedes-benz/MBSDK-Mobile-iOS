//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - VehicleDoorModel

/// Representation of door related attributes
public struct VehicleDoorModel {
	
    /// Door Lock state
	public let lockState: StatusAttributeType<LockStatus, NoUnit>
    /// Door Open state
	public let state: StatusAttributeType<DoorStatus, NoUnit>
}


// MARK: - VehicleDoorsModel

/// Representation all kind of doors
public struct VehicleDoorsModel {
	
    /// Door overview decklid
	public let decklid: VehicleDoorModel
    /// Door overview front left
	public let frontLeft: VehicleDoorModel
    /// Door overview front right
	public let frontRight: VehicleDoorModel
    /// Door lock status for all doors/decklid combined
	public let lockStatusOverall: StatusAttributeType<DoorLockOverallStatus, NoUnit>
    /// Door overview rear left
	public let rearLeft: VehicleDoorModel
    /// Door overview rear right
	public let rearRight: VehicleDoorModel
    /// Door open status for all doors/decklid combined
	public let statusOverall: StatusAttributeType<DoorOverallStatus, NoUnit>
}
