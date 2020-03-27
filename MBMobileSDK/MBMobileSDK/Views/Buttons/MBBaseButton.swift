//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

class MBBaseButton: UIButton, MBControlActivityConformable, MBStylable {

	// MARK: Typealias
	typealias DidTouchUpInside = () -> Void
	
    // MARK: - Properties

	var loadingIndicatorStyle: MBLoadingIndicatorView.Style = .white
    var backgroundAction: MBControlActivityAction = .loadingIndicator
    var internalImage: UIImage?

	var didTouchUpInsideClosure: DidTouchUpInside?
    //'stylingClosure' is needed if button theming needs to be adapted when highlighted state changes
    var stylingClosure: ((MBBaseButton) -> Void)?
    //'roundingClosure' is needed for partial rounding of the button to ensure that
    //the layer's mask frame is updated when the button's bounds change
    var roundingClosure: ((UIView) -> Void)?
    var layoutClosure: ((UIButton) -> Void)?

    override var buttonType: UIButton.ButtonType {
        return .custom
    }

    override var isHighlighted: Bool {
        didSet {
            self.stylingClosure?(self)
        }
    }

	private func handleEnabledStatus() {
		if self.isEnabled {
			self.alpha = 1.0
		} else {
			self.alpha = 0.5
		}
	}

	override var isEnabled: Bool {
		didSet {
			self.handleEnabledStatus()
		}
	}


    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
		
        self.commonInit()
    }

    func commonInit() {

        self.addTarget(self, action: #selector(self.handleTouchUpInside), for: .touchUpInside)
		self.adjustsImageWhenHighlighted = false
        self.adjustsImageWhenDisabled = false
		self.backgroundColor = .clear
        self.tintColor = .white
		self.titleLabel?.apply(style: .button1())
		self.setTitleColor(UIColor.white, for: .normal)
        self.handleEnabledStatus()
        self.setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layoutClosure?(self)
        self.roundingClosure?(self)
    }
    
    func setupUI() {
        // Override in subclass
    }
	
	
    // MARK: - Convenience methods

    func didTouchUpInside(action: @escaping DidTouchUpInside) {
        self.didTouchUpInsideClosure = action
    }
	
	
    // MARK: - Inner button targets -

    @objc private func handleTouchUpInside() {
        self.didTouchUpInsideClosure?()
    }

	
    // MARK: - Disable button emthods

    override func setTitleShadowColor(_ color: UIColor?, for state: UIControl.State) {
		
    }
    
    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        self.internalImage = self.imageView?.image
        super.setImage(image, for: state)
        self.bringSubviewToFront(self.titleLabel!)
        self.bringSubviewToFront(self.imageView!)
    }
    
    func setTitleColorInternal(_ color: UIColor?, for state: UIControl.State) {
        super.setTitleColor(color, for: state)
    }
    
    func setImageInternal(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(image, for: state)
    }

    override var intrinsicContentSize: CGSize {
        var newContentSize = super.intrinsicContentSize
        newContentSize.width += self.titleEdgeInsets.left + self.titleEdgeInsets.right
        return newContentSize
    }
}

extension MBBaseButton {

	func setBackgroundColor(_ color: MBColorName, for controlState: UIControl.State) {
		self.setBackgroundColor(color.color, for: controlState)
	}

    func setBackgroundColor(_ color: UIColor, for controlState: UIControl.State) {
        let colorImage = UIImage.mb_With(color: color)
        self.setBackgroundImage(colorImage, for: controlState)
    }
}

extension MBBaseButton {

    func style(using styleProvider: MBButtonStyleProvider) {

        self.stylingClosure = { (button) in

            let currentState = button.state
            let titleColor = styleProvider.titleColor(for: currentState)
            button.setTitleColor(titleColor, for: currentState)

            let backgroundColor = styleProvider.backgroundColor(for: currentState)
            
            button.setBackgroundColor(backgroundColor, for: currentState)
            button.layoutIfNeeded()
            button.subviews.first?.layer.cornerRadius = button.layer.cornerRadius
            
            button.imageView?.tintColor = styleProvider.imageViewTintColor
            button.layer.borderColor = styleProvider.borderColor(for: currentState)?.cgColor
            button.layer.borderWidth = styleProvider.borderWidth

            styleProvider.customizeButton(button)
        }
		
        self.stylingClosure?(self)
    }
}
