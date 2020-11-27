//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

@testable import MBMobileSDK

class MockJsonConvertible: JsonConvertible {
    var jsonResult: [String: Any]?
    
    func toJson<T: Encodable>(_ obj: T) -> [String: Any]? {
        return jsonResult
    }
}
