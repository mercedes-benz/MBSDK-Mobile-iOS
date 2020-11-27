//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of valet protect violation data
public struct ValetProtectViolationModel {

    public let id: Int
    public let violationtype: ValetProtectViolationType
    public let time: Int
    public let coordinate: ValetProtectCenterModel?
    public let valetProtect: ValetProtectModel
    
    // MARK: - Init

    public init(id: Int, violationtype: ValetProtectViolationType, time: Int, coordinate: ValetProtectCenterModel?, valetProtect: ValetProtectModel) {
        
        self.id = id
        self.violationtype = violationtype
        self.time = time
        self.coordinate = coordinate
        self.valetProtect = valetProtect
    }
}
