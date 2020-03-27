//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

struct MBUXGradientBorderConfiguration: MBUXConfigurationConformable {

    var type: MBUXConfigurationType {
        return .border
    }

    let borderType: MBUXBorderType
    let borderWidth: CGFloat = 1
    let colors: [UIColor]
    let cornerRadius: CGFloat
    let frame: CGRect
    let locations: [NSNumber]
    let opacity: Float
    let startPoint: CGPoint
    let endPoint: CGPoint
    let compositingFilter: LayerCompositingFilter?

    func generateLayer() -> CALayer {

        // We need to correct the border radius because we inset the bounds
        let correctedCornerRadius: CGFloat

        // Add the border inside of the button
        let newFrame: CGRect

        switch borderType {
        case .inner:
            newFrame = frame.inset(by: UIEdgeInsets(top: borderWidth/2, left: borderWidth/2, bottom: borderWidth/2, right: borderWidth/2))
            correctedCornerRadius = (frame.height - borderWidth) * (cornerRadius / frame.height)
        case .outer:
            newFrame = frame.inset(by: UIEdgeInsets(top: -borderWidth/2, left: -borderWidth/2, bottom: -borderWidth/2, right: -borderWidth/2))
            correctedCornerRadius = (frame.height - borderWidth) * (cornerRadius / frame.height)
        case .center:
            newFrame = frame
            correctedCornerRadius = (frame.height + borderWidth/2) * (cornerRadius / frame.height)
        }
        let path = UIBezierPath(roundedRect: newFrame, cornerRadius: correctedCornerRadius)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = borderWidth
        shapeLayer.fillColor = UIColor.clear.cgColor

        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map({$0.cgColor})
        gradient.locations = locations
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.mask = shapeLayer
        gradient.opacity = opacity

        if let compositingFilter = compositingFilter {
            gradient.compositingFilter = compositingFilter.rawValue
        }

        return gradient
    }
}
