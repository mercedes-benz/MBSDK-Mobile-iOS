//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

/// Database class of vehicle data object
@objcMembers public class DBVehicleModel: Object {
	
	// MARK: Properties
	dynamic var baumuster: String = ""
	dynamic var carline: String?
	dynamic var dataCollectorVersion: String?
	dynamic var doorsCount: String?
	dynamic var fin: String = ""
	dynamic var finOrVin: String = ""
	dynamic var fuelType: String?
	dynamic var handDrive: String?
	dynamic var hasAuxHeat: Bool = false
	dynamic var hasFacelift: Bool = false
	dynamic var indicatorImageUrl: String = ""
	dynamic var licensePlate: String = ""
	dynamic var model: String = ""
	dynamic var normalizedProfileControlSupport: String = ""
	dynamic var pending: String = ""
    dynamic var profileSyncSupport: String?
	dynamic var roofType: String?
	dynamic var starArchitecture: String?
	dynamic var tcuHardwareVersion: String?
	dynamic var tcuSoftwareVersion: String?
	dynamic var tirePressureMonitoringType: String?
	dynamic var trustLevel: Int = 0
	dynamic var vin: String = ""
	dynamic var windowsLiftCount: String?
    dynamic var vehicleConnectivity: String?
	dynamic var vehicleSegment: String = VehicleSegment.default.rawValue
	
    dynamic var paintCode: String?
    dynamic var paintDescription: String?
    dynamic var upholsteryCode: String?
    dynamic var upholsteryDescription: String?
    dynamic var lineCode: String?
    dynamic var lineDescription: String?
    
	let dealers = List<DBVehicleDealerItemModel>()
	let isOwner = RealmOptional<Bool>()
	
	
	// MARK: - Realm
	
	override public static func primaryKey() -> String? {
		return "finOrVin"
	}
	
	public override func isEqual(_ object: Any?) -> Bool {
		
		guard let rhs = object as? DBVehicleModel else {
			return false
		}
		
		let compareDealers = zip(self.dealers, rhs.dealers).compactMap {
			return $0.0.isEqual($0.1) ? nil : true
		}
		
		return self.baumuster == rhs.baumuster &&
			self.carline == rhs.carline &&
			self.dataCollectorVersion == rhs.dataCollectorVersion &&
			self.doorsCount == rhs.doorsCount &&
			self.fin == rhs.fin &&
			self.finOrVin == rhs.finOrVin &&
			self.fuelType == rhs.fuelType &&
			self.handDrive == rhs.handDrive &&
			self.hasAuxHeat == rhs.hasAuxHeat &&
			self.hasFacelift == rhs.hasFacelift &&
			self.licensePlate == rhs.licensePlate &&
			self.isOwner.value == rhs.isOwner.value &&
			self.model == rhs.model &&
			self.pending == rhs.pending &&
            self.profileSyncSupport == rhs.profileSyncSupport &&
			self.roofType == rhs.roofType &&
			self.starArchitecture == rhs.starArchitecture &&
			self.tcuHardwareVersion == rhs.tcuHardwareVersion &&
			self.tcuSoftwareVersion == rhs.tcuSoftwareVersion &&
			self.tirePressureMonitoringType == rhs.tirePressureMonitoringType &&
			self.trustLevel == rhs.trustLevel &&
			self.vin == rhs.vin &&
			self.windowsLiftCount == rhs.windowsLiftCount &&
            self.vehicleConnectivity == rhs.vehicleConnectivity &&
			self.vehicleSegment == rhs.vehicleSegment &&
			(compareDealers.isEmpty && self.dealers.count == rhs.dealers.count)
	}
}
