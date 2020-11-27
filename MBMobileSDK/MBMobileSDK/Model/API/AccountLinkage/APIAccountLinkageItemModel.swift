//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

struct APIAccountLinkageItemModel: Decodable {
	
	let accountType: String?
	let bannerUrl: String?
    let connectionState: String
	let description: String?
	let descriptionLinks: [String: String]?
	let iconUrl: String?
	let isDefault: Bool?
	let legalTextUrl: String?
	let possibleActions: [APIAccountLinkageActionModel]?
	let userAccountId: String?
	let vendorDisplayName: String?
	let vendorId: String?
}
