//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit

struct APIVehicleServiceModel: Codable {

    let activationStatus: ServiceActivationStatus
    let allowedActions: [String]
    let id: Int
	let missingData: APIVehicleServiceMissingDataModel?
    let name: String
	let shortDescription: String?
    let shortName: String?
	let prerequisiteChecks: [APIVehicleServicePrerequisiteModel]?
	let rights: [ServiceRight]
	
	
	// MARK: - Init

    init(from decoder: Decoder) throws {

		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		self.activationStatus   = container.decodeSafelyIfPresent(ServiceActivationStatus.self, forKey: .activationStatus) ?? .unknown
		self.allowedActions     = container.decodeArraySafelyIfPresent(String.self, forKey: .allowedActions) ?? []
		self.id                 = try container.decode(Int.self, forKey: .id)
		self.missingData		= try container.decodeIfPresent(APIVehicleServiceMissingDataModel.self, forKey: .missingData)
		self.name               = try container.decode(String.self, forKey: .name)
		self.shortDescription   = try container.decodeIfPresent(String.self, forKey: .shortDescription)
		self.shortName          = try container.decodeIfPresent(String.self, forKey: .shortName)
		self.prerequisiteChecks = container.decodeArraySafelyIfPresent(APIVehicleServicePrerequisiteModel.self, forKey: .prerequisiteChecks)
		self.rights             = container.decodeArraySafelyIfPresent(ServiceRight.self, forKey: .rights) ?? []
    }
}
