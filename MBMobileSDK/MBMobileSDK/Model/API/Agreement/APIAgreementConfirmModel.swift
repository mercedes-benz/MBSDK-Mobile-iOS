//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIAgreementConfirmModel: Codable {
	
	let allUserAgreementConsentsSet: Bool?
	let unsuccessfulSetDocIds: [String]
	
	
	// MARK: - Init
	
	init(from decoder: Decoder) throws {
		
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		self.allUserAgreementConsentsSet = try container.decode(Bool.self, forKey: .allUserAgreementConsentsSet)
		self.unsuccessfulSetDocIds       = container.decodeArraySafelyIfPresent(String.self, forKey: .unsuccessfulSetDocIds) ?? []
	}
}
