//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import MBNetworkKit

struct APIAssignmentPreconditionModel: Decodable {
	let assignmentType: String?
	let baumusterDescription: String?
	let mercedesMePinRequired: Bool?
	let salesDesignation: String?
	let termsOfUseRequired: Bool?
	let vin: String
}

extension APIAssignmentPreconditionModel: MBErrorConformable {
    
    public var errorDescription: String? {
        return nil
    }
}
