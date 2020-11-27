//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of top image cache
struct TopImageCacheModel {
	let etag: String
    let vin: String
	let components: [TopImageComponentCacheModel]
}

struct TopImageComponentCacheModel {
    let name: String
    let imageData: Data?
}
