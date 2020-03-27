//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

extension CGFloat {

    static let MBDefaultButtonCornerRadius = CGFloat(10.0)
}

typealias MBButtonStyle = MBViewStyle<MBBaseButton>
private let radialGradientLayerName = "radialGradientLayer"

extension MBViewStyle where T: MBBaseButton {

    static var primary: MBButtonStyle {
        let customStyle = self.buttonStyle(from: MBPrimaryButtonStyle())
        return self.primaryButtonStyle.compose(with: customStyle)
    }

    static var secondary: MBButtonStyle {
        let customStyle = self.buttonStyle(from: MBSecondaryButtonStyle())
        return self.secondaryButtonStyle.compose(with: customStyle)
    }

    static var primaryText: MBButtonStyle {
        let customStyle = self.buttonStyle(from: MBPrimaryTextButtonStyle())
        return self.textButtonStyle.compose(with: customStyle)
    }

    static var secondaryText: MBButtonStyle {
        let customStyle = self.buttonStyle(from: MBSecondaryTextButtonStyle())
        return self.textButtonStyle.compose(with: customStyle)
    }
    
    static var plain: MBButtonStyle {
        let customStyle = self.buttonStyle(from: MBPlainButtonStyle())
        return self.defaultButtonStyle.compose(with: customStyle)
    }

    static func rounded(radius: CGFloat) -> MBButtonStyle {
        return MBButtonStyle { (button) in
            
            button.layer.cornerRadius = radius
        }
    }
    
    static func primary(radius: CGFloat) -> MBButtonStyle {
        return MBButtonStyle { (button) in
            
            button.layer.cornerRadius = radius
            self.addPrimaryEffect(to: button, with: radius)
        }
    }
    
    static func secondary(radius: CGFloat) -> MBButtonStyle {
        return MBButtonStyle { (button) in
            
            button.layer.cornerRadius = radius
            self.addShadow(to: button)
        }
    }

    private static func buttonStyle(from provider: MBButtonStyleProvider) -> MBButtonStyle {
        return MBButtonStyle { (button) in
            button.style(using: provider)
        }
    }

    private static var defaultButtonStyle: MBButtonStyle {
        let roundedStyle = MBButtonStyle.rounded(radius: .MBDefaultButtonCornerRadius)
        return self.imageAlignmentButtonWithBackground.compose(with: roundedStyle)
    }
    
    private static var primaryButtonStyle: MBButtonStyle {
        let primaryStyle = MBButtonStyle.primary(radius: .MBDefaultButtonCornerRadius)
        return self.imageAlignmentButtonWithPrimaryStyle.compose(with: primaryStyle)
    }
    
    private static var secondaryButtonStyle: MBButtonStyle {
        let primaryStyle = MBButtonStyle.secondary(radius: .MBDefaultButtonCornerRadius)
        return self.imageAlignmentButtonWithBackground.compose(with: primaryStyle)
    }

    private static var textButtonStyle: MBButtonStyle {
        let roundedStyle = MBButtonStyle.rounded(radius: .MBDefaultButtonCornerRadius)
        return self.imageAlignmentButtonWithFlatText.compose(with: roundedStyle)
    }

    private static var imageAlignmentButtonWithBackground: MBButtonStyle {
        return MBButtonStyle { (button) in
            button.layoutClosure = { (buttonToLayout) in
                MBButtonStyle.layoutWithImageInset(buttonToLayout: buttonToLayout, outerInset: 16.0)
            }
        }
    }
    
    private static var imageAlignmentButtonWithPrimaryStyle: MBButtonStyle {
        return MBButtonStyle { (button) in
            button.layoutClosure = { (buttonToLayout) in
                
                MBButtonStyle.layoutWithImageInset(buttonToLayout: buttonToLayout, outerInset: 16.0)
                
                let bounds = buttonToLayout.bounds
                let cornerRadius = buttonToLayout.layer.cornerRadius

                for layer in buttonToLayout.layer.sublayers ?? [] {

                    // Set the path of the CAShapeLayers
                    if let shapeLayer = layer as? CAShapeLayer {
                        shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
                    } else if layer.name == radialGradientLayerName {
                        // Remove the Radial Gradient layers
                        layer.removeFromSuperlayer()
                    }
                }

                // Add the Radial Gradient layers with the new rect
                for item in self.getPrimaryEffectConfigurations(bounds: bounds, with: cornerRadius) where item is MBUXRadialGradientConfiguration {
                    
                    let layer = item.generateLayer()
                    layer.name = radialGradientLayerName
                    buttonToLayout.layer.addSublayer(layer)
                }
            }
        }
    }

    private static var imageAlignmentButtonWithFlatText: MBButtonStyle {
        return MBButtonStyle { (button) in
            button.layoutClosure = { (buttonToLayout) in
				
				guard buttonToLayout.titleLabel?.font != nil else {
                    return
                }
                
                MBButtonStyle.layoutWithImageInset(buttonToLayout: buttonToLayout, outerInset: 0.0)
            }
        }
    }

    private static func layoutWithImageInset(buttonToLayout: UIButton, outerInset: CGFloat) {
		
		guard let font = buttonToLayout.titleLabel?.font else {
            return
        }
		
        buttonToLayout.contentHorizontalAlignment = .left
        let title = buttonToLayout.title(for: buttonToLayout.state) ?? ""
        let textWidth = (title as NSString).size(withAttributes: [.font: font]).width
        let imageWidth = buttonToLayout.image(for: buttonToLayout.state)?.size.width ?? 0.0
        let imageLeadingSpace = outerInset

        var leftInset = buttonToLayout.bounds.width / 2.0 - textWidth / 2.0 - imageWidth

        if leftInset < outerInset {
            leftInset = outerInset
        }
        
        // check if we get a collision of image and title and resolve it
        if imageWidth > CGFloat.ulpOfOne {
            buttonToLayout.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: imageLeadingSpace, bottom: 0.0, right: 0.0)
            if leftInset < buttonToLayout.imageEdgeInsets.left + 8.0 {
                leftInset = buttonToLayout.imageEdgeInsets.left + 8.0
            }
        }

        buttonToLayout.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: leftInset, bottom: 0.0, right: outerInset)
    }
    
    private static func addPrimaryEffect(to button: MBBaseButton, with radius: CGFloat) {
        
        self.addShadow(to: button)
        
        // Layers
        
        for item in self.getPrimaryEffectConfigurations(bounds: button.bounds, with: radius) {
            
            let layer = item.generateLayer()
            
            if item is MBUXRadialGradientConfiguration {
                layer.name = radialGradientLayerName
            }
            button.layer.addSublayer(layer)
        }
    }
    
    private static func getPrimaryEffectConfigurations(bounds: CGRect, with radius: CGFloat) -> [MBUXConfigurationConformable] {
        
        // MARK: - Layer 1
        let solidBorder =  MBUXSolidBorderConfiguration(borderType: .inner, borderWidth: 1/UIScreen.main.scale, borderColor: MBColorName.risAccentPrimary.color, frame: bounds, cornerRadius: radius)
        
        // MARK: - Layer 2
        let reflexColors = [UIColor.white.withAlphaComponent(0.2),
                            UIColor.white.withAlphaComponent(0)]
        
        let reflexLayer = MBUXRadialGradientConfiguration(colors: reflexColors,
                                                          locations: [0.0, 1.0],
                                                          bounds: bounds,
                                                          scaleRatio: CGSize(width: 1.8, height: 1.1),
                                                          sizeModifier: 2,
                                                          alpha: 0.8,
                                                          center: CGPoint(x: bounds.width / 2, y: bounds.height),
                                                          angle: 15,
                                                          maskLayer: self.generateReflexMask(for: bounds))
        
        // MARK: - Layer 3
        let colors = [UIColor.white.withAlphaComponent(0.2),
                      UIColor.white.withAlphaComponent(0)]
        
        let gradient = MBUXRadialGradientConfiguration(colors: colors,
                                                       locations: [0.0, 1.0],
                                                       bounds: bounds,
                                                       scaleRatio: CGSize(width: 1, height: 1),
                                                       sizeModifier: 2,
                                                       alpha: 0.8,
                                                       center: CGPoint(x: bounds.width / 2, y: -bounds.height * 0.25))
        
        return [
            gradient,
            reflexLayer,
            solidBorder
        ]
    }
    
    private static func addShadow(to button: UIButton) {
        
        // Shadow Layer
        button.layer.shadowRadius = 4
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.24
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.masksToBounds = false
    }
    
    private static func generateReflexMask(for bounds: CGRect) -> CALayer {
        
        let maskBezierPath = UIBezierPath()
        
        let anglePoints: CGFloat = 9
        
        maskBezierPath.move(to: CGPoint.zero)
        maskBezierPath.addLine(to: CGPoint(x: bounds.width * 0.5 + anglePoints, y: 0))
        maskBezierPath.addLine(to: CGPoint(x: bounds.width * 0.5 - anglePoints, y: bounds.height))
        maskBezierPath.addLine(to: CGPoint(x: 0, y: bounds.height))
        maskBezierPath.addLine(to: CGPoint.zero)
        maskBezierPath.close()
        
        let maskShape = CAShapeLayer()
        maskShape.path = maskBezierPath.cgPath
        maskShape.fillColor = UIColor.red.cgColor
        return maskShape
    }
}
