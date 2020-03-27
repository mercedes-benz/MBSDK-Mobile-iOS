//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

class MBLoadingIndicatorView: UIView {
    
    private struct Constants {
        
        static let animationDuration = 1.5
        static let rotationAnimationKey = "RotationAnimation"
        static let basicAnimationKey = "transform.rotation.z"
        static let clearColor = UIColor.white.withAlphaComponent(0).cgColor // UIColor.clear has a black color channel
		static let fadeAnimationDuration = 0.4
		static let delay = 0.2
    }


    // MARK: - Properties
    
    private var style: MBLoadingIndicatorView.Style = .blue
    private lazy var gradientLayer: CAGradientLayer = {
        
        let gradientLayer = CAGradientLayer()
        if #available(iOS 12.0, *) {
            
            gradientLayer.type = .conic
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        }
        return gradientLayer
    }()
    
    /// Current animation state
    private var isAnimating = false

	/// A Boolean value that controls whether the receiver is hidden when the animation is stopped.
	@IBInspectable
	var hidesWhenStopped: Bool = false
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(style: MBLoadingIndicatorView.Style) {
        super.init(frame: CGRect.zero)
        
        self.setIndicatorStyle(with: style)
    }
    
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		self.setIndicatorStyle(with: style)
	}
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupUI()
    }
    
    // MARK: - Public
    
    func startAnimating() {

        guard isAnimating == false else {
            return
        }
        
        self.isAnimating = true
        
		if self.hidesWhenStopped {
			UIView.animate(withDuration: Constants.fadeAnimationDuration, delay: 0, animations: {
				self.alpha = 1
			})
		}
		self.isHidden = false
        self.gradientLayer.removeAnimation(forKey: Constants.rotationAnimationKey)
        let rotationAnimation = CABasicAnimation(keyPath: Constants.basicAnimationKey)
        rotationAnimation.toValue = 2 * CGFloat.pi
        rotationAnimation.duration = Constants.animationDuration
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.fillMode = .forwards
        rotationAnimation.isRemovedOnCompletion = false
        self.gradientLayer.add(rotationAnimation, forKey: Constants.rotationAnimationKey)
    }
    
    func stopAnimating() {
        
        guard isAnimating == true else {
            return
        }

		if self.hidesWhenStopped {
			UIView.animate(withDuration: Constants.fadeAnimationDuration, delay: 0, animations: {
				self.alpha = 0
			}, completion: { _ in
				self.gradientLayer.removeAllAnimations()
                self.isAnimating = false
			})
		} else {
			self.gradientLayer.removeAllAnimations()
            self.isAnimating = false
		}
    }
    
    func setIndicatorStyle(with style: MBLoadingIndicatorView.Style) {
        
        self.style = style
        
        switch style {
            
        case .white:    self.gradientLayer.colors = [Constants.clearColor, UIColor.white.cgColor]
        case .blue:     self.gradientLayer.colors = [Constants.clearColor, MBColorName.risAccentPrimary.color.cgColor]
        }
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        
        self.gradientLayer.frame = self.bounds
        self.setIndicatorStyle(with: self.style)
        
        let lineWidth: CGFloat = self.bounds.height / 6.5
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let radius = (min(self.bounds.width, self.bounds.height) - lineWidth) / 2
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        let mask = CAShapeLayer()
        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.white.cgColor
        mask.lineWidth = lineWidth
        mask.path = path.cgPath
        
        self.gradientLayer.mask = mask
		self.layer.addSublayer(gradientLayer)

		if self.hidesWhenStopped && !self.isAnimating {
			self.alpha = 0
		}
    }
}


// MARK: - MBLoadingIndicatorView

extension MBLoadingIndicatorView {
    
    enum Style {
		case blue
        case white
    }
}
