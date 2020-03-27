//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

struct MBUXRadialGradientConfiguration: MBUXConfigurationConformable {

    var type: MBUXConfigurationType {
        return .fill
    }

    let colors: [UIColor]
    let locations: [CGFloat]
    let bounds: CGRect
    let scaleRatio: CGSize
    let sizeModifier: CGFloat
    let alpha: CGFloat
    let center: CGPoint
    var angle: CGFloat?
    var compositingFilter: LayerCompositingFilter?
    var maskLayer: CALayer?

    init(
        colors: [UIColor],
        locations: [CGFloat],
        bounds: CGRect,
        scaleRatio: CGSize,
        sizeModifier: CGFloat,
        alpha: CGFloat,
        center: CGPoint,
        angle: CGFloat? = nil,
        compositingFilter: LayerCompositingFilter? = nil,
        maskLayer: CALayer? = nil) {

        self.colors = colors
        self.locations = locations
        self.bounds = bounds
        self.scaleRatio = scaleRatio
        self.sizeModifier = sizeModifier
        self.angle = angle
        self.alpha = alpha
        self.center = center
        self.compositingFilter = compositingFilter
        self.maskLayer = maskLayer
    }

    func generateLayer() -> CALayer {

        let layer = MBRadialGradientLayer()
        layer.frame = bounds
        let view = MBRadialGradientView(frame: bounds)

        view.colors = colors
        view.locations = locations
        view.draw(inLayer: layer, atCenter: center, withAngle: angle, alpha: alpha, sizeModifier: sizeModifier, scaleRatio: scaleRatio, compositingFilter: compositingFilter)
        layer.compositingFilter = compositingFilter?.rawValue

        if let mask = maskLayer {
            layer.mask = mask
        }

        return layer
    }
}
