//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

struct APIToasAgreementModel: Codable {
    let documents: [APIToasDocumentModel]?
    let checkboxes: [APIToasCheckboxModel]?
}
