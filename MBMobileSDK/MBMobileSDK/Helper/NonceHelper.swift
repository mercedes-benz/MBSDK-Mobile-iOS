//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

protocol NonceHelping {
    func getNonce() -> String
}

class NonceHelper: NonceHelping {
    func getNonce() -> String {
        return UUID().uuidString
    }
}
