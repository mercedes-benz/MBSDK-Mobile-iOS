//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIVehicleAssignedSubuserModel: Decodable {
    
    let pendingSubusers: [APIVehicleAssignedUserModel]?
    let temporarySubusers: [APIVehicleAssignedUserModel]?
	let validSubusers: [APIVehicleAssignedUserModel]?
}
