//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

struct MBUXSolidColorConfiguration: MBUXConfigurationConformable {

    var type: MBUXConfigurationType {
        return .fill
    }

    let color: UIColor
    let opacity: Float
    let bounds: CGRect
    let mask: CALayer?

    init(color: UIColor, opacity: Float, bounds: CGRect, mask: CALayer? = nil) {
        self.color = color
        self.opacity = opacity
        self.bounds = bounds
        self.mask = mask
    }

    func generateLayer() -> CALayer {

        let layer = CALayer()
        layer.frame = bounds
        layer.backgroundColor = color.cgColor
		layer.cornerRadius = 10

        if let mask = self.mask {
            layer.mask = mask
        }

        return layer
    }
}
