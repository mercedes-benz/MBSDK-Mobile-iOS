//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import RealmSwift
import MBRealmKit

class SendToCarCapabilitiesDbModelMapper: DbModelMapping {
	
	typealias BusinessModel = SendToCarCapabilitiesModel
	typealias DbModel = DBSendToCarCapabilitiesModel
	
	private struct Constants {
		static let separator: String = ","
	}
	
	func map(_ dbModel: DBSendToCarCapabilitiesModel) -> SendToCarCapabilitiesModel {
		
		let capabilities: [SendToCarCapability] = dbModel.capabilities
			.components(separatedBy: Constants.separator)
			.compactMap { SendToCarCapability(rawValue: $0) }
		let preconditions: [SendToCarPrecondition] = dbModel.preconditions
			.components(separatedBy: Constants.separator)
			.compactMap { SendToCarPrecondition(rawValue: $0) }
		
		return SendToCarCapabilitiesModel(capabilities: capabilities,
										  finOrVin: dbModel.finOrVin,
										  preconditions: preconditions)
	}
	
	func map(_ businessModel: SendToCarCapabilitiesModel) -> DBSendToCarCapabilitiesModel {
		
		let dbSendToCarCapabilitiesModel = DBSendToCarCapabilitiesModel()
		dbSendToCarCapabilitiesModel.capabilities = businessModel.capabilities.map { $0.rawValue }.joined(separator: Constants.separator)
		dbSendToCarCapabilitiesModel.finOrVin = businessModel.finOrVin
		dbSendToCarCapabilitiesModel.preconditions = businessModel.preconditions.map { $0.rawValue }.joined(separator: Constants.separator)
        return dbSendToCarCapabilitiesModel
	}
}
