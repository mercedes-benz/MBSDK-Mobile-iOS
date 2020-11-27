//
//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

protocol JsonConvertible {
    func toJson<T: Encodable>(_ obj: T) -> [String: Any]?
}

class JsonConverter: JsonConvertible {
    
    func toJson<T: Encodable>(_ obj: T) -> [String: Any]? {
        
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(obj)
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            LOG.E("Error during JSON serialization: \(error).")
            return nil
        }
    }
}
