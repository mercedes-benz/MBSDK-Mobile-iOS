//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift

class CarKitDatabaseModelMapper {
	
	// MARK: - Public - BusinessModel

	static func map(dbVehicleServiceMissingDataModel: DBVehicleServiceMissingDataModel?) -> VehicleServiceMissingDataModel? {

		guard let dbVehicleServiceMissingDataModel = dbVehicleServiceMissingDataModel,
			let accountType = AccountType(rawValue: dbVehicleServiceMissingDataModel.accountLinkageType) else {
				return nil
		}

		let missingAccountLinkage = VehicleServiceAccountLinkageModel(accountType: accountType,
																	  mandatory: dbVehicleServiceMissingDataModel.accountLinkageMandatory)
		return VehicleServiceMissingDataModel(missingAccountLinkage: missingAccountLinkage)
	}
	
	
	// MARK: - Public - DatabaseModel
	
	static func map(requestImage: VehicleImageRequest) -> DBImageModel {
		
		let dbImage        = DBImageModel()
		dbImage.background = requestImage.background.rawValue
		dbImage.centered   = requestImage.centered
		dbImage.degrees    = requestImage.degrees.rawValue
		dbImage.night      = requestImage.night
		dbImage.roofOpen   = requestImage.roofOpen
		
		switch requestImage.size {
		case .jpeg(let size):
			dbImage.isPng = false
			dbImage.size  = size.rawValue
			
		case .png(let size):
			dbImage.isPng = true
			dbImage.size  = size.rawValue
		}
		
		return dbImage
	}
	
	static func map(service: VehicleServiceModel, dbService: DBVehicleServiceModel) {
		
		dbService.activationStatus   = service.activationStatus.rawValue
		dbService.allowedActions     = service.allowedActions.map { $0.rawValue }.joined(separator: ",")
		dbService.missingData		 = self.map(missingAccountLinkage: service.missingData?.missingAccountLinkage)
		dbService.name               = service.name
		dbService.rights             = service.rights.map { $0.rawValue }.joined(separator: ",")
		dbService.serviceDescription = service.description
		dbService.shortName          = service.shortName
		dbService.prerequisites.append(objectsIn: self.map(servicePrerequisites: service.prerequisites))
	}
	
	static func map(service: VehicleServiceModel, finOrVin: String, sortIndex: Int, categoryName: String, categorySortIndex: Int) -> DBVehicleServiceModel {

		let dbService                = DBVehicleServiceModel()
		dbService.activationStatus   = service.activationStatus.rawValue
		dbService.allowedActions     = service.allowedActions.map { $0.rawValue }.joined(separator: ",")
		dbService.categoryName       = categoryName
		dbService.categorySortIndex  = categorySortIndex
		dbService.finOrVin			 = finOrVin
		dbService.id                 = service.serviceId
		dbService.missingData		 = self.map(missingAccountLinkage: service.missingData?.missingAccountLinkage)
		dbService.name               = service.name
		dbService.rights             = service.rights.map { $0.rawValue }.joined(separator: ",")
		dbService.serviceDescription = service.description
		dbService.sortIndex          = sortIndex
		dbService.shortName          = service.shortName
		dbService.prerequisites.append(objectsIn: self.map(servicePrerequisites: service.prerequisites))
		dbService.setPrimaryKey()
		return dbService
	}
	
	static func map(missingAccountLinkage: VehicleServiceAccountLinkageModel?) -> DBVehicleServiceMissingDataModel? {
		
		guard let missingAccountLinkage = missingAccountLinkage else {
			return nil
		}
		
		let dbMissingData = DBVehicleServiceMissingDataModel()
		dbMissingData.accountLinkageMandatory = missingAccountLinkage.mandatory
		dbMissingData.accountLinkageType = missingAccountLinkage.accountType.rawValue
		return dbMissingData
	}
	
	static func map(servicePrerequisite: VehicleServicePrerequisiteModel) -> DBVehicleServicePrerequisiteModel {
		
		let dbPrerequisite           = DBVehicleServicePrerequisiteModel()
		dbPrerequisite.actions       = servicePrerequisite.actions.map { $0.rawValue }.joined(separator: ",")
		dbPrerequisite.missingFields = servicePrerequisite.missingFields.map { $0.rawValue }.joined(separator: ",")
		dbPrerequisite.name          = servicePrerequisite.name.rawValue
		return dbPrerequisite
	}
	
	static func map(servicePrerequisites: [VehicleServicePrerequisiteModel]) -> [DBVehicleServicePrerequisiteModel] {
		return servicePrerequisites.map { self.map(servicePrerequisite: $0) }
	}
	
	static func map(finOrVin: String, serviceGroups: [VehicleServiceGroupModel]) -> [DBVehicleServiceModel] {
		return serviceGroups.enumerated().flatMap { (categoryIndex, category) -> [DBVehicleServiceModel] in
			return category.services.enumerated().map { (serviceIndex, service) -> DBVehicleServiceModel in
				return self.map(service: service,
								finOrVin: finOrVin,
								sortIndex: serviceIndex,
								categoryName: category.group,
								categorySortIndex: categoryIndex)
			}
		}
	}
}
