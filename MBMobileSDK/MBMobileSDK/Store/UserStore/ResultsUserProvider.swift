//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBRealmKit

/// Abstract database provider to access the database model through a business model
public class ResultsUserProvider: RealmDataSourceProvider<DBUserModel, UserModel> {
	
	/// Returns the business model based on the database model
	///
	/// - Parameters:
	///   - model: DBUserModel
	/// - Returns: Optional UserModel
	public override func map(model: DBUserModel) -> UserModel? {
		return DatabaseModelMapper.map(dbUserModel: model)
	}
	
	
	// MARK: - Internal
	
	func map() -> UserModel? {
		
		guard let item = self.results?.first else {
			return nil
		}
        
		return self.map(model: item)
	}
}
