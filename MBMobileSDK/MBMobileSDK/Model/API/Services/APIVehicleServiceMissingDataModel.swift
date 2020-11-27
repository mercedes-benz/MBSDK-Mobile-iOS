//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

struct APIVehicleServiceMissingDataModel: Codable {
	let missingAccountLinkage: APIVehicleServiceAccountLinkageModel?
}


struct APIVehicleServiceAccountLinkageModel: Codable {
	let accountType: String
	let mandatory: Bool
}
