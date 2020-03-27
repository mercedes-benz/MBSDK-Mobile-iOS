//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

struct MBUXLinearGradientConfiguration: MBUXConfigurationConformable {

    var type: MBUXConfigurationType {
        return .fill
    }

    var colors: [UIColor]
    var locations: [NSNumber]
    let opacity: Float
    let direction: MBGradientDirection = .bottomToTop
    let bounds: CGRect

    func generateLayer() -> CALayer {

        let gradient = MBBaseGradientLayer()

        gradient.colors = colors.map({$0.cgColor})
        gradient.locations = locations
        gradient.opacity = opacity
        gradient.frame = bounds
        gradient.direction = direction

        return gradient
    }
}
