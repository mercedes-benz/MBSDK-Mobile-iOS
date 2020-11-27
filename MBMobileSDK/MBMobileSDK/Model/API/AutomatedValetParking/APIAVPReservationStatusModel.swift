//
//  Copyright © 2020 Daimler AG. All rights reserved.
//

import Foundation

struct APIAVPReservationStatusModel: Decodable {
    let reservationId: String
    let driveType: String
    let driveStatus: String
    let errorIds: [String]?
    let estimatedTimeOfArrival: String?
    let parkedLocation: String?
}
