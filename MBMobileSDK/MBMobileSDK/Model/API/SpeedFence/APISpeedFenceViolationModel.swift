//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

struct APISpeedFenceViolationModel: Decodable {
    let coordinates: APICoordinateModel?
	let speedfence: APISpeedFenceModel?
    let onboardfence: APIOnboardFenceModel?
    let time: Int?
    let violationid: Int?
}
