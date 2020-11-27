//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIActiveTimes: Decodable {
    let days: [Int]
    let begin: Int
    let end: Int
}
