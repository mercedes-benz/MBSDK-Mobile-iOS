//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

struct APIAccountLinkageModel: Decodable {
	
	let accounts: [APIAccountLinkageItemModel]?
	let accountType: String?
	let bannerImageUrl: String?
    let description: String?
	let iconUrl: String?
	let heading: String?
	let name: String?
	let visible: Bool?
}
