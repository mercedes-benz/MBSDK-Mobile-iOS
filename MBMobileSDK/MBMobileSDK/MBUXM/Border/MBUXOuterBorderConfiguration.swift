//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

struct MBUXOuterBorderConfiguration: MBUXConfigurationConformable {

    var type: MBUXConfigurationType {
        return .border
    }

    let borderWidth: CGFloat
    let borderColor: UIColor
    let frame: CGRect
    let cornerRadius: CGFloat

    func generateLayer() -> CALayer {

        let path = UIBezierPath(roundedRect: frame.insetBy(dx: borderWidth, dy: borderWidth), cornerRadius: cornerRadius)

        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.strokeColor = borderColor.cgColor
        shape.lineWidth = borderWidth
        shape.fillColor = UIColor.clear.cgColor

        return shape
    }
}
