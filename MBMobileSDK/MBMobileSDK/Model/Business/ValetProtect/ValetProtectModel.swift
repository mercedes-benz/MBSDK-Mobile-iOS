//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of valet protect data
public struct ValetProtectModel: Encodable {

    public let name: String?
    public let violationtypes: [ValetProtectViolationType]
    public let center: ValetProtectCenterModel?
    public let radius: ValetProtectRadiusModel?
    
	
    // MARK: - Init

    public init(name: String?, violationtypes: [ValetProtectViolationType], center: ValetProtectCenterModel?, radius: ValetProtectRadiusModel?) {
        
        self.name = name
        self.violationtypes = violationtypes
        self.center = center
        self.radius = radius
    }
}
