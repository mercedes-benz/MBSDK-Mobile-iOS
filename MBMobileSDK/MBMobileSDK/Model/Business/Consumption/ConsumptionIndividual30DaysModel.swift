//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of a individual consumption overr the last 30 days
public struct ConsumptionIndividual30DaysModel {

    /// Timestamp in seconds since 1970
    public let lastUpdated: Int?
    /// Unit of the value
    public let unit: ConsumptionUnit
    /// Consumption average over the last 30 days
    public let value: Double
}
