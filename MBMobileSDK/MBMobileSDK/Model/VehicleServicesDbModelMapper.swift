//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import MBRealmKit

class VehicleServicesDbModelMapper: DbModelMapping {
	
	typealias BusinessModel = VehicleServiceModel
	typealias DbModel = DBVehicleServiceModel
	
	func map(_ dbModel: DBVehicleServiceModel) -> VehicleServiceModel {
		
		let activationStaus: ServiceActivationStatus = {
			
			let defaultActivationStatus = ServiceActivationStatus(rawValue: dbModel.activationStatus) ?? .unknown
			guard let pendingState = ServicePendingState(rawValue: dbModel.pending),
				pendingState != .none else {
					return defaultActivationStatus
			}
			
			switch pendingState {
			case .activation:	return .activationPending
			case .deactivation:	return .deactivationPending
			case .none:			return defaultActivationStatus
			}
		}()
		
		return VehicleServiceModel(activationStatus: activationStaus,
								   allowedActions: dbModel.allowedActions.components(separatedBy: ",").compactMap { ServiceAction(rawValue: $0) },
								   description: dbModel.serviceDescription ?? "",
								   finOrVin: dbModel.finOrVin,
								   id: dbModel.id,
								   missingData: self.map(dbModel.missingData),
								   name: dbModel.name,
								   prerequisites: dbModel.prerequisites.map { self.map($0) },
								   shortName: dbModel.shortName,
								   rights: dbModel.rights.components(separatedBy: ",").compactMap { ServiceRight(rawValue: $0) })
	}
	
	func map(_ businessModel: VehicleServiceModel) -> DBVehicleServiceModel {
		
		let dbService                = DBVehicleServiceModel()
		dbService.activationStatus   = businessModel.activationStatus.rawValue
		dbService.allowedActions     = businessModel.allowedActions.map { $0.rawValue }.joined(separator: ",")
//		dbService.categoryName       = categoryName
//		dbService.categorySortIndex  = categorySortIndex
		dbService.finOrVin			 = businessModel.finOrVin
		dbService.id                 = businessModel.serviceId
		dbService.missingData		 = self.map(businessModel.missingData?.missingAccountLinkage)
		dbService.name               = businessModel.name
		dbService.rights             = businessModel.rights.map { $0.rawValue }.joined(separator: ",")
		dbService.serviceDescription = businessModel.description
//		dbService.sortIndex          = sortIndex
		dbService.shortName          = businessModel.shortName
		dbService.prerequisites.append(objectsIn: self.map(businessModel.prerequisites))
		dbService.setPrimaryKey()
		return dbService
	}
	
	
	// MARK: - Helper
	
	private func map(_ businessModel: VehicleServiceAccountLinkageModel?) -> DBVehicleServiceMissingDataModel? {
		
		guard let businessModel = businessModel else {
			return nil
		}
		
		let dbMissingData = DBVehicleServiceMissingDataModel()
		dbMissingData.accountLinkageMandatory = businessModel.mandatory
		dbMissingData.accountLinkageType = businessModel.accountType.rawValue
		return dbMissingData
	}
	
	private func map(_ businessModel: VehicleServicePrerequisiteModel) -> DBVehicleServicePrerequisiteModel {
		
		let dbPrerequisite           = DBVehicleServicePrerequisiteModel()
		dbPrerequisite.actions       = businessModel.actions.map { $0.rawValue }.joined(separator: ",")
		dbPrerequisite.missingFields = businessModel.missingFields.map { $0.rawValue }.joined(separator: ",")
		dbPrerequisite.name          = businessModel.name.rawValue
		return dbPrerequisite
	}
	
	private func map(_ businessModels: [VehicleServicePrerequisiteModel]) -> [DBVehicleServicePrerequisiteModel] {
		return businessModels.map { self.map($0) }
	}
	
	private func map(_ dbModel: DBVehicleServiceMissingDataModel?) -> VehicleServiceMissingDataModel? {
		
		guard let dbModel = dbModel,
			let accountType = AccountType(rawValue: dbModel.accountLinkageType) else {
				return nil
		}
		
		let missingAccountLinkage = VehicleServiceAccountLinkageModel(accountType: accountType,
																	  mandatory: dbModel.accountLinkageMandatory)
		return VehicleServiceMissingDataModel(missingAccountLinkage: missingAccountLinkage)
	}
	
	private func map(_ dbModel: DBVehicleServicePrerequisiteModel) -> VehicleServicePrerequisiteModel {
		return VehicleServicePrerequisiteModel(actions: dbModel.actions.components(separatedBy: ",").compactMap { ServiceAction(rawValue: $0) },
											   missingFields: dbModel.missingFields.components(separatedBy: ",").compactMap { ServiceMissingFields(rawValue: $0) },
											   name: PrerequisiteCheck(rawValue: dbModel.name) ?? .license)
	}
}
