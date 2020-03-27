//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

/// A view with a radial gradient.

// Philipp: I used a view instead of a layer mostly because it is way easier to handle the angle and center of the gradient. Feel free to change this in the future

// swiftlint:disable line_length
// swiftlint:disable function_parameter_count
class MBRadialGradientView: UIView {

    var colors: [UIColor]? {
        didSet {
            (self.layer as? MBRadialGradientLayer)?.colors = self.colors?.map({$0.cgColor})
        }
    }

    var locations: [CGFloat]? {
        didSet {
            (self.layer as? MBRadialGradientLayer)?.locations = self.locations
        }
    }

    override class var layerClass: AnyClass {
        return MBRadialGradientLayer.self
    }

    /**
     Adds the gradient layer and its gradient to the given layer with the given parameters

     - Parameter layer: The layer to which the gradient should be added
     - Parameter center: The center point of the gradient
     - Parameter angle: The angle of the gradient in degrees
     - Parameter alpha: The alpha of the gradient
     - Parameter sizeModifier: This parameter is important to make the gradient large enough to span the whole layer. With the normal bounds it can happen that the gradient does not cover the whole layer and we would therefore get "sharp edges" visible for the gradient. To prevent this we apply a multiplier to make the gradient bounds larger and shrink the actual gradient by the same amount. This way the gradient still has the same size but we dont get "sharp edges"
     - Parameter scaleRatio: This is the relative size of the radial gradient compared to the given layer itself. The gradient is normally square and looks the same in x and y direction. We use this ratio to stretch and clinch the gradient
     - Parameter compositingFilter: Optional parameter to add a blend mode to the gradient. (Example multiplyBlendMode, lightenBlendMode)
     */
    func draw(inLayer layer: CALayer, atCenter center: CGPoint, withAngle angle: CGFloat?, alpha: CGFloat, sizeModifier: CGFloat, scaleRatio: CGSize, compositingFilter: LayerCompositingFilter?) {

        self.frame = CGRect(x: 0, y: 0, width: layer.bounds.width, height: layer.bounds.width)

        self.backgroundColor = UIColor.clear

        self.alpha = alpha

        if let compositingFilter = compositingFilter {
            self.layer.compositingFilter = compositingFilter.rawValue
        }

        if let locations = self.locations {
            self.locations = locations.map({$0 / sizeModifier})
        }

        // We get the photoshop coordinates from the design department. They start with 0/0 in the upper left. We need to handle this
        self.center = CGPoint(x: center.x, y: layer.bounds.height - center.y)

        var transform = CGAffineTransform.identity

        if let angle = angle {
            transform = transform.rotated(by: CGFloat(angle * CGFloat.pi / 180))
        }

        // Adjust the size and form of the gradient with the scaleRatio and sizeModifier
        transform = transform.scaledBy(x: layer.bounds.width / self.bounds.width * scaleRatio.width * sizeModifier,
                                       y: layer.bounds.height / self.bounds.height * scaleRatio.height * sizeModifier)

        self.transform = transform

        self.layer.setNeedsDisplay()

        layer.addSublayer(self.layer)
    }

    // Not used at the moment
    /// The start point of the radial gradient.
    /// Range from 0 to 1, defaults to 0.5(center).
    //    var startPoint: CGPoint? {
    //        didSet {
    //            (self.layer as! RadialGradientLayer).startPoint = startPoint
    //        }
    //    }

    /// The end point of the radial gradient.
    /// Range from 0 to 1, defaults to 0.5(center).
    //    var endPoint: CGPoint? {
    //        didSet {
    //            (self.layer as! RadialGradientLayer).endPoint = endPoint
    //        }
    //    }
}
