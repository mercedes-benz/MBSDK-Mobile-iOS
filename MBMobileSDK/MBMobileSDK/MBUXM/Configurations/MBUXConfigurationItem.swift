//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

enum MBUXConfigurationType {
    case fill
    case shadow
    case border
}

// MARK: - Protocol

protocol MBUXConfigurationConformable {

    var type: MBUXConfigurationType { get }
    func generateLayer() -> CALayer
}
