//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBRealmKit

/// Abstract database provider to access the database model through a business model
public class ResultsVehicleProvider: RealmDataSourceProvider<DBVehicleModel, VehicleModel> {
	
	/// Returns the index in which an element of the collection
	///
	/// - Parameters:
	///   - finOrVin: Vehicle identifier
	/// - Returns: Optional Int
	public func indexOf(finOrVin: String) -> Int? {
		return self.results?.firstIndex(where: { $0.finOrVin == finOrVin })
	}
	
	/// Returns the business model based on the database model
	///
	/// - Parameters:
	///   - model: DBVehicleModel
	/// - Returns: Optional VehicleModel
	public override func map(model: DBVehicleModel) -> VehicleModel? {
		return VehicleDbModelMapper().map(model)
	}
}
