//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBRealmKit

/// Representation of vehicle data
public struct VehicleModel {
	
	/// sales related baumuster information
	public let baumuster: String
    /// Vehicle's car line, e.g. '203'
	public let carline: String?
    /// Telematic Control Unit Data Collector Version
	public let dataCollectorVersion: DataCollectorVersion?
    /// List of vehicle dealers
	public let dealers: [VehicleDealerItemModel]
    /// Number of doors
	public let doorsCount: DoorsCount?
	/// Fahrzeug Identifizierungs Nummer
	public let fin: String
    /// Fuel type
	public let fuelType: FuelType?
    /// Steering wheel position (left/right)
	public let handDrive: HandDriven?
    /// Indicates if vehicle supports Auxiliary heating
	public let hasAuxHeat: Bool
	/// represent the mopf value from vcb and indicates if vehicle has facelift (Modellpflege)
	public let hasFacelift: Bool
    /// Contains the URL to an indicator image for the master user of the vehicle.
    /// Only available if the requesting user is a sub user.
	public let indicatorImageUrl: URL?
	/// Indicates whether the user is owner or user of the vehicle.
	public let isOwner: Bool?
    /// License Plate
	public let licensePlate: String
	/// correct model name of vehicle
	public let model: String
    /// Indicates whether the vehicle does support normalized profile control
	public let normalizedProfileControlSupport: ProfileControlSupport?
    /// Current assign-action state
	public let pending: AssignmentPendingState?
    /// Indicates the support state for automatic profile sync.
    public let profileSyncSupport: ProfileSyncSupport?
    /// Sunroof type
	public let roofType: RoofType?
    /// HeadUnit architecture type
	public let starArchitecture: StarArchitecture?
    /// HeadUnit architecture version
	public let tcuHardwareVersion: TcuHardwareVersion?
    /// Telematic Control Unit's software version
	public let tcuSoftwareVersion: TcuSoftwareVersion?
    /// Tire pressure sensor type
	public let tirePressureMonitoringType: TirePressureMonitoringType?
    /// Trustlevel
    /// + 1: No trust
    /// + 2: Vehicle access granted
    /// + 3: Vehicle access granted + Successful personal identification
	public let trustLevel: Int
	/// Vehicle identification number
	public let vin: String?
    /// Number of windows, that can be lifted
	public let windowsLiftCount: WindowsLiftCount?
    /// Indicates if vehicle supports connectivity, one out of 'No connectivity',
    /// 'ODB-adapter connectivity' or 'Built in connectivity'
    public let vehicleConnectivity: VehicleConnectivity?
    /// Indicates vehicle segment
	public let vehicleSegment: VehicleSegment
    
    /// Paint information of the car like code="144", description="digitalweiss metallic"
    public let paint: VehicleAmenityModel?
    /// Information about the upholstery, like code="651", description="Ledernachbildung ARTICO"
    public let upholstery: VehicleAmenityModel?
    /// Line of the vehicle, like code="956", description="Sport-Paket AMG Plus"
    public let line: VehicleAmenityModel?
}


// MARK: - Entity

extension VehicleModel: Entity {
	
	public var id: String {
		return self.finOrVin
	}
}


// MARK: - Extension

extension VehicleModel {
	
	/// vehicle identifier
	public var finOrVin: String {
		
		let vin: String? = {
			return self.vin?.isEmpty == true ? nil : self.vin
		}()
		return vin ?? self.fin
	}
	
	/// preferred sales dealer
	public var salesDealer: VehicleDealerItemModel? {
		return self.dealers.first(where: { $0.role == .sales })
	}
	
	/// preferred service dealer
	public var serviceDealer: VehicleDealerItemModel? {
		return self.dealers.first(where: { $0.role == .service })
	}
}
