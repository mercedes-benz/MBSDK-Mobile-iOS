//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of active times
public class ActiveTimesModel: Encodable {
    
    public let begin: Int
    public let end: Int
    public let days: [Day]
    
    // MARK: - Init

    public init(begin: Int, end: Int, days: [Day]) {
        
        self.begin = begin
        self.end = end
        self.days = days
    }
    
    enum CodingKeys: String, CodingKey {
        case begin
        case end
        case days
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(begin, forKey: .begin)
        try container.encode(end, forKey: .end)
        let  shifteddays = days.map {
            $0.mapShifteddPlusOneDay()
        }
        try container.encode(shifteddays, forKey: .days)
    }
}
