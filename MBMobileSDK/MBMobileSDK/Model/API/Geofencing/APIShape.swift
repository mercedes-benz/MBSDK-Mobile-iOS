//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public struct APIShape: Decodable {
    let center: APICoordinateModel?
    let radius: Double?
    let coordinates: [APICoordinateModel]?
}
