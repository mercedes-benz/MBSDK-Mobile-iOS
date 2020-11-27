//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIVehicleDataModel: Decodable {
	
	let carline: String?
	let dataCollectorVersion: DataCollectorVersion?
	let dealers: APIVehicleDealerItemsModel?
	let doorsCount: DoorsCount?
	let fin: String?
	let fuelType: FuelType?
	let handDrive: HandDriven?
	let hasAuxHeat: Bool?
	let licensePlate: String?
	let indicatorImageUrl: String?
	let isOwner: Bool?
	let mopf: Bool?
	let normalizedProfileControlSupport: ProfileControlSupport?
    let profileSyncSupport: ProfileSyncSupport?
	let roofType: RoofType?
	let salesRelatedInformation: APIVehicleSalesRelatedInformationModel?
	let starArchitecture: String?
	let tcuHardwareVersion: String?
	let tcuSoftwareVersion: String?
	let technicalInformation: APIVehicleTechnicalInformationModel?
	let tirePressureMonitoringType: TirePressureMonitoringType?
	let trustLevel: Int?
	let vin: String?
	let windowsLiftCount: WindowsLiftCount?
    let vehicleConnectivity: VehicleConnectivity?
	let vehicleSegment: VehicleSegment?
}
