//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

struct MBUXSolidBorderConfiguration: MBUXConfigurationConformable {

    var type: MBUXConfigurationType {
        return .border
    }

    let borderType: MBUXBorderType
    let borderWidth: CGFloat
    let borderColor: UIColor
    let frame: CGRect
    let cornerRadius: CGFloat

    func generateLayer() -> CALayer {
        // We need to correct the border radius because we inset the bounds
//        let correctedCornerRadius: CGFloat
        let newFrame: CGRect

        switch borderType {
        case .inner:
            newFrame = frame.inset(by: UIEdgeInsets(top: borderWidth/2, left: borderWidth/2, bottom: borderWidth/2, right: borderWidth/2))
//            correctedCornerRadius = (frame.height - borderWidth) * (cornerRadius / frame.height)
			
        case .outer:
            newFrame = frame.inset(by: UIEdgeInsets(top: -borderWidth/2, left: -borderWidth/2, bottom: -borderWidth/2, right: -borderWidth/2))
//            correctedCornerRadius = (frame.height - borderWidth) * (cornerRadius / frame.height)
			
        case .center:
            newFrame = frame
//            correctedCornerRadius = (frame.height + borderWidth/2) * (cornerRadius / frame.height)
        }

        let path = UIBezierPath(roundedRect: newFrame, cornerRadius: cornerRadius)

        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.strokeColor = borderColor.cgColor
        shape.lineWidth = borderWidth
        shape.fillColor = UIColor.clear.cgColor
		shape.allowsEdgeAntialiasing = true
        return shape
    }
}
