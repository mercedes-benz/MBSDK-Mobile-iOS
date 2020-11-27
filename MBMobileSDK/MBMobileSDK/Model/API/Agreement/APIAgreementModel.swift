//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIAgreementModel: Codable {
    
    let documentData: String
    let documents: [APIAgreementDocModel]
}
