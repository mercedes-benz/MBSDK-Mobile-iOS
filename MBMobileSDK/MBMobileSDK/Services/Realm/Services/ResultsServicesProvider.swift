//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBRealmKit

/// Abstract database provider to access the database model through a business model
public class ResultsServicesProvider: RealmDataSourceProvider<DBVehicleServiceModel, VehicleServiceModel> {
	
	/// Returns the business model based on the database model
	///
	/// - Parameters:
	///   - model: DBVehicleModel
	/// - Returns: VehicleServiceModel
	public override func map(model: DBVehicleServiceModel) -> VehicleServiceModel {
		return VehicleServicesDbModelMapper().map(model)
	}
	
	/// Returns a array of business model
	public func allServices() -> [VehicleServiceModel] {
		
		var services = [VehicleServiceModel]()
		for index in 0..<self.count {
			
			guard let service = self.item(at: index) else {
				continue
			}
			services.append(service)
		}
		
		return services
	}
}


/// Abstract database provider to access the database model through a business model
public class ResultsServiceGroupProvider: RealmDataSourceProvider<DBVehicleServiceModel, VehicleServiceGroup> {
	
	/// Returns the business model based on the database model
	///
	/// - Parameters:
	///   - model: DBVehicleModel
	/// - Returns: VehicleServiceGroup
	public override func map(model: DBVehicleServiceModel) -> VehicleServiceGroup {
		
		let provider = VehicleServicesDbStore().fetchProvider(with: model.finOrVin,
                                                              categoryName: model.categoryName)
		return VehicleServiceGroup(group: model.categoryName,
								   provider: provider)
	}
}

public extension ResultsServiceGroupProvider {
	
	func item(at index: Int, rights: [ServiceRight] = ServiceRight.allCases) -> BusinessModelType? {

		let databaseItem: DatabaseModelType? = self.results?.item(at: index)
		guard let item = databaseItem else {
			return nil
		}

		return self.map(model: item, rights: rights)
	}
	
	func map(model: DatabaseModelType, rights: [ServiceRight] = ServiceRight.allCases) -> VehicleServiceGroup {
		
		let provider = VehicleServicesDbStore().fetchProvider(with: model.finOrVin,
                                                              categoryName: model.categoryName,
                                                              rights: rights)
		return VehicleServiceGroup(group: model.categoryName,
								   provider: provider)
	}
}
