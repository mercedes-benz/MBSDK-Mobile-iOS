//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIAgreementDocModel: Codable {
	
	let acceptedByUser: Bool
	let acceptedLocale: String?
    let documentId: String
    let version: Int
}
