//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift
import MBRealmKit

class VehicleDbModelMapper: DbModelMapping {
	
	typealias BusinessModel = VehicleModel
	typealias DbModel = DBVehicleModel
	
	func map(_ dbModel: DBVehicleModel) -> VehicleModel {
		return VehicleModel(baumuster: dbModel.baumuster,
							carline: dbModel.carline,
							dataCollectorVersion: DataCollectorVersion(rawValue: dbModel.dataCollectorVersion ?? ""),
							dealers: self.map(dbModel.dealers),
							doorsCount: DoorsCount(rawValue: dbModel.doorsCount ?? ""),
							fin: dbModel.fin,
							fuelType: FuelType(rawValue: dbModel.fuelType ?? ""),
							handDrive: HandDriven(rawValue: dbModel.handDrive ?? ""),
							hasAuxHeat: dbModel.hasAuxHeat,
							hasFacelift: dbModel.hasFacelift,
							indicatorImageUrl: URL(string: dbModel.indicatorImageUrl),
							isOwner: dbModel.isOwner.value,
							licensePlate: dbModel.licensePlate,
							model: dbModel.model,
							normalizedProfileControlSupport: ProfileControlSupport(rawValue: dbModel.normalizedProfileControlSupport),
							pending: AssignmentPendingState(rawValue: dbModel.pending),
							profileSyncSupport: ProfileSyncSupport(rawValue: dbModel.profileSyncSupport ?? ""),
							roofType: RoofType(rawValue: dbModel.roofType ?? ""),
							starArchitecture: StarArchitecture(rawValue: dbModel.starArchitecture ?? ""),
							tcuHardwareVersion: TcuHardwareVersion(rawValue: dbModel.tcuHardwareVersion ?? ""),
							tcuSoftwareVersion: TcuSoftwareVersion(rawValue: dbModel.tcuSoftwareVersion ?? ""),
							tirePressureMonitoringType: TirePressureMonitoringType(rawValue: dbModel.tirePressureMonitoringType ?? ""),
							trustLevel: dbModel.trustLevel,
							vin: dbModel.vin,
							windowsLiftCount: WindowsLiftCount(rawValue: dbModel.windowsLiftCount ?? ""),
							vehicleConnectivity: VehicleConnectivity(rawValue: dbModel.vehicleConnectivity ?? ""),
							vehicleSegment: VehicleSegment(rawValue: dbModel.vehicleSegment) ?? .default,
							paint: VehicleAmenityModel(code: dbModel.paintCode,
													   description: dbModel.paintDescription),
							upholstery: VehicleAmenityModel(code: dbModel.upholsteryCode,
															description: dbModel.upholsteryDescription),
							line: VehicleAmenityModel(code: dbModel.lineCode,
													  description: dbModel.lineDescription))
	}
	
	func map(_ businessModel: VehicleModel) -> DBVehicleModel {
		
		let dbVehicle                        = DBVehicleModel()
		dbVehicle.baumuster                  = businessModel.baumuster
		dbVehicle.carline                    = businessModel.carline
		dbVehicle.dataCollectorVersion       = businessModel.dataCollectorVersion?.rawValue
		dbVehicle.doorsCount                 = businessModel.doorsCount?.rawValue
		dbVehicle.fin                        = businessModel.fin
		dbVehicle.finOrVin                   = businessModel.finOrVin
		dbVehicle.fuelType                   = businessModel.fuelType?.rawValue
		dbVehicle.handDrive                  = businessModel.handDrive?.rawValue
		dbVehicle.hasAuxHeat                 = businessModel.hasAuxHeat
		dbVehicle.hasFacelift                = businessModel.hasFacelift
		dbVehicle.indicatorImageUrl          = businessModel.indicatorImageUrl?.absoluteString ?? ""
		dbVehicle.isOwner.value              = businessModel.isOwner
		dbVehicle.licensePlate               = businessModel.licensePlate
		dbVehicle.lineCode                   = businessModel.line?.code
		dbVehicle.lineDescription            = businessModel.line?.description
		dbVehicle.model                      = businessModel.model
		dbVehicle.normalizedProfileControlSupport = businessModel.normalizedProfileControlSupport?.rawValue ?? ""
		dbVehicle.paintCode                  = businessModel.paint?.code
		dbVehicle.paintDescription           = businessModel.paint?.description
		dbVehicle.pending                    = businessModel.pending?.rawValue ?? ""
        dbVehicle.profileSyncSupport         = businessModel.profileSyncSupport?.rawValue
		dbVehicle.roofType                   = businessModel.roofType?.rawValue
		dbVehicle.starArchitecture           = businessModel.starArchitecture?.rawValue
		dbVehicle.tcuHardwareVersion         = businessModel.tcuHardwareVersion?.rawValue
		dbVehicle.tcuSoftwareVersion         = businessModel.tcuSoftwareVersion?.rawValue
		dbVehicle.tirePressureMonitoringType = businessModel.tirePressureMonitoringType?.rawValue
		dbVehicle.trustLevel                 = businessModel.trustLevel
		dbVehicle.upholsteryCode             = businessModel.upholstery?.code
		dbVehicle.upholsteryDescription      = businessModel.upholstery?.description
		dbVehicle.vin                        = businessModel.vin ?? ""
		dbVehicle.windowsLiftCount           = businessModel.windowsLiftCount?.rawValue
		dbVehicle.vehicleConnectivity        = businessModel.vehicleConnectivity?.rawValue
		dbVehicle.vehicleSegment             = businessModel.vehicleSegment.rawValue
		
		dbVehicle.dealers.append(objectsIn: self.map(businessModel.dealers))
		
		return dbVehicle
	}
	
	
	// MARK: - Helper
	
	private func map(_ businessModel: DealerAddressModel?) -> DBDealerAddressModel? {

		guard let address = businessModel else {
			return nil
		}

		let dbDealerAddressModel = DBDealerAddressModel()
		dbDealerAddressModel.addressAddition = address.addressAddition ?? ""
		dbDealerAddressModel.city = address.city ?? ""
		dbDealerAddressModel.countryIsoCode = address.countryIsoCode ?? ""
		dbDealerAddressModel.district = address.district ?? ""
		dbDealerAddressModel.street = address.street ?? ""
		dbDealerAddressModel.zipCode = address.zipCode ?? ""
		return dbDealerAddressModel
	}
	
	private func map(_ businessModel: DealerMerchantModel?) -> DBDealerMerchantModel? {

		guard let merchant = businessModel else {
			return nil
		}

		let dbDealerMerchantModel = DBDealerMerchantModel()
		dbDealerMerchantModel.legalName = merchant.legalName ?? ""
		dbDealerMerchantModel.address = self.map(merchant.address)
		dbDealerMerchantModel.openingHours = self.map(merchant.openingHours)
		return dbDealerMerchantModel
	}
	
	private func map(_ businessModel: DealerOpeningDay?) -> DBDealerOpeningDayModel? {

		guard let openingDay = businessModel else {
			return nil
		}
		let dbDealerOpeningDayModel = DBDealerOpeningDayModel()
		switch openingDay.status {
		case .some(.open(let from, let until)):
			dbDealerOpeningDayModel.status = "OPEN"
			let period = DBDealerDayPeriodModel()
			period.until = until ?? ""
			period.from = from ?? ""
			dbDealerOpeningDayModel.periods.append(period)
		case .some(.closed):
			dbDealerOpeningDayModel.status = "CLOSE"
		default:
			break
		}
		return dbDealerOpeningDayModel
	}
	
	private func map(_ businessModel: DealerOpeningHoursModel?) -> DBDealerOpeningHoursModel? {

		guard let openingHours = businessModel else {
			return nil
		}

		let dbDealerOpeningHoursModel = DBDealerOpeningHoursModel()
		dbDealerOpeningHoursModel.monday = self.map(openingHours.monday)
		dbDealerOpeningHoursModel.tuesday = self.map(openingHours.tuesday)
		dbDealerOpeningHoursModel.wednesday = self.map(openingHours.wednesday)
		dbDealerOpeningHoursModel.thursday = self.map(openingHours.thursday)
		dbDealerOpeningHoursModel.friday = self.map(openingHours.friday)
		dbDealerOpeningHoursModel.sunday = self.map(openingHours.sunday)
		dbDealerOpeningHoursModel.saturday = self.map(openingHours.saturday)
		return dbDealerOpeningHoursModel
	}
	
	private func map(_ businessModel: VehicleDealerItemModel) -> DBVehicleDealerItemModel {

		let dbVehicleDealerItemModel      = DBVehicleDealerItemModel()
		dbVehicleDealerItemModel.dealerId = businessModel.dealerId
		dbVehicleDealerItemModel.role     = businessModel.role.rawValue
		dbVehicleDealerItemModel.merchant = self.map(businessModel.merchant)
		return dbVehicleDealerItemModel
	}
	
	func map(_ businessModels: [VehicleDealerItemModel]) -> [DBVehicleDealerItemModel] {
		return businessModels.map { self.map($0) }
	}
	
	private func map(_ dbModel: DBDealerAddressModel?) -> DealerAddressModel? {

		guard let address = dbModel else {
			return nil
		}
		return DealerAddressModel(street: address.street,
								  addressAddition: address.addressAddition,
								  zipCode: address.zipCode,
								  city: address.city,
								  district: address.district,
								  countryIsoCode: address.countryIsoCode)
	}

	private func map(_ dbModel: DBDealerMerchantModel?) -> DealerMerchantModel? {

		guard let merchant = dbModel else {
			return nil
		}
		return DealerMerchantModel(legalName: merchant.legalName,
								   address: self.map(merchant.address),
								   openingHours: self.map(merchant.openingHours))
	}
	
	private func map(_ dbModel: DBDealerOpeningDayModel) -> DealerOpeningStatus {

		let lastPeriod = dbModel.periods.last
		switch dbModel.status {
		case "OPEN":
			return DealerOpeningStatus.open(from: lastPeriod?.from ?? "", until: lastPeriod?.until ?? "")
		case "CLOSE":
			return DealerOpeningStatus.closed
		default:
			return DealerOpeningStatus.closed
		}
	}
	
	private func map(_ dbModel: DBDealerOpeningDayModel?) -> DealerOpeningDay {

		guard let day = dbModel else {
			return DealerOpeningDay(status: nil)
		}
		return DealerOpeningDay(status: self.map(day))
	}
	
	private func map(_ dbModel: DBDealerOpeningHoursModel?) -> DealerOpeningHoursModel? {

		guard let openingHours = dbModel else {
			return nil
		}
		return DealerOpeningHoursModel(monday: self.map(openingHours.monday),
									   tuesday: self.map(openingHours.tuesday),
									   wednesday: self.map(openingHours.wednesday),
									   thursday: self.map(openingHours.thursday),
									   friday: self.map(openingHours.friday),
									   saturday: self.map(openingHours.saturday),
									   sunday: self.map(openingHours.sunday))
	}
	
	func map(_ dbModel: List<DBVehicleDealerItemModel>) -> [VehicleDealerItemModel] {
		return dbModel.compactMap { (dealerItem) -> VehicleDealerItemModel? in

			guard let role = DealerRole(rawValue: dealerItem.role) else {
				return nil
			}

			return VehicleDealerItemModel(dealerId: dealerItem.dealerId,
										  role: role,
										  merchant: self.map(dealerItem.merchant))
		}
	}
}
