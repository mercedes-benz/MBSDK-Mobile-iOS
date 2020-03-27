//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

@objc protocol MBTextFieldDelegate: class {

    @objc optional func textFieldShouldBeginEditing(_ textField: MBTextField) -> Bool
    @objc optional func textFieldDidBeginEditing(_ textField: MBTextField)
    @objc optional func textFieldShouldEndEditing(_ textField: MBTextField) -> Bool
    @objc optional func textFieldDidEndEditing(_ textField: MBTextField)
    @objc optional func textFieldDidEndEditing(_ textField: MBTextField, reason: UITextField.DidEndEditingReason)
    @objc optional func textField(_ textField: MBTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    @objc optional func textFieldShouldClear(_ textField: MBTextField) -> Bool
    @objc optional func textFieldShouldReturn(_ textField: MBTextField) -> Bool
}

class MBTextField: UITextField {
	
	typealias RightButtonAction = () -> Void
	
	// MARK: - Structs
	
	private struct Constants {

		static let defaultLeftRightMargin = CGFloat(16)
        static let animationDuration: TimeInterval = 0.2
        static let textPadding = UIEdgeInsets(top: 20, left: Constants.defaultLeftRightMargin, bottom: 0, right: Constants.defaultLeftRightMargin)
        static let rightViewPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: Constants.defaultLeftRightMargin)
        static let floatingLabelHeight: CGFloat = 20
        static let padding: CGFloat = 16

        static func floatingLabelTopPositon(for bounds: CGRect, postion: FloatingLabelPositon) -> CGFloat {
            switch postion {
            case .top:		return 4
            case .center:	return 0.5 * bounds.height - 0.5 * floatingLabelHeight
            }
        }
    }
	
	// MARK: - Lazy
	
	private lazy var floatingPlaceholderLabel: MBCaptionLabel = {
		
		let label = MBCaptionLabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.alpha = 0
		return label
	}()
	
	lazy private var placeholderTopConstraint: NSLayoutConstraint = {
		return self.floatingPlaceholderLabel.topAnchor.constraint(equalTo: self.topAnchor,
																  constant: Constants.floatingLabelTopPositon(for: self.frame, postion: .center))
	}()
    
    private lazy var errorLabel: MBBody1Label = {
        
        let label = MBBody1Label()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = MBColorName.risStatusError.color
        label.numberOfLines = 0
        return label
    }()
	
    // MARK: - Enum
	
    private enum FloatingLabelPositon {
        case top
        case center
    }

    
    // MARK: - Properties (public)
	
	override var attributedPlaceholder: NSAttributedString? {
		didSet {
			self.floatingPlaceholderLabel.attributedText = self.attributedPlaceholder
		}
	}
	
	override var isEnabled: Bool {
		didSet {
			self.alpha = self.isEnabled ? 1.0 : 0.5
		}
	}
	
    override var placeholder: String? {
        didSet {
            self.applyAttributedPlaceholderText()
        }
    }

	var showPlaceholderAfterInputText: Bool {
		return true
	}
	
    override var text: String? {
        didSet {
            self.handleTextChange()
        }
    }

    override var delegate: UITextFieldDelegate? {
        get {
            return self
        }
        //swiftlint:disable unused_setter_value
        set {
            super.delegate = self
        }
    }

    weak var mbDelegate: MBTextFieldDelegate?

    var leftPadding: CGFloat {
        return Constants.textPadding.left
    }
	
	// MARK: - Properties
	
	private var hasMandatoryStyle = false
	private var rightButtonAction: RightButtonAction?
	
    
	// MARK: - Public
	
	func setMandatoryErrorStyle() {

		self.hasMandatoryStyle = true
		
		let color = MBColorName.risStatusErrorDarkbackground.color
		self.layer.borderColor = color.cgColor
		self.layer.borderWidth = 1.0
	}
    
    func setMandatoryErrorStyle(with message: String) {
        
        self.setMandatoryErrorStyle()
        self.addErrorLabel()
        self.errorLabel.text = message
    }
	
	
    // MARK: - Initializer
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }


    // MARK: - View Lifecycle
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.commonInit()
    }


    // MARK: - UI Setup
	
    func commonInit() {

		self.borderStyle = .none
        self.backgroundColor = MBColorName.risGrey5.color
        self.textColor = MBColorName.risBlack.color
        self.font = MBTypography.body1.font
        self.tintColor = MBColorName.risBlack.color
		self.layer.cornerRadius = 10
		self.layer.masksToBounds = true
		
        self.setupFloatingLabel()
        self.applyAttributedPlaceholderText()
		self.setNormalStyle()
        self.addTarget(self, action: #selector(self.handleTextChange), for: .editingChanged)
        self.delegate = self
		
		self.configureAccessibility()
    }
	
	private func configureAccessibility() {
		
		self.isAccessibilityElement = true
		self.floatingPlaceholderLabel.isAccessibilityElement = false
	}
	
	private func setEditStyle() {
		
		self.layer.borderColor = MBColorName.risAccentPrimary.color.cgColor
		self.layer.borderWidth = 1.0
		
		if self.hasMandatoryStyle {
			self.resetMandatoryView()
		}
	}
	
	private func setNormalStyle() {
		
		self.layer.borderColor = MBColorName.risGrey2.color.cgColor
		self.layer.borderWidth = 0.5
		
		if self.hasMandatoryStyle {
			self.resetMandatoryView()
		}
	}
	
    private func setupFloatingLabel() {
		
        self.addSubview(self.floatingPlaceholderLabel)

        NSLayoutConstraint.activate([
            self.placeholderTopConstraint,
            self.floatingPlaceholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.leftPadding),
            self.floatingPlaceholderLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 8),
            self.floatingPlaceholderLabel.heightAnchor.constraint(equalToConstant: Constants.floatingLabelHeight)
            ])
    }

	private func applyAttributedPlaceholderText() {
		
		let color = isEditing ? MBColorName.risAccentPrimary.color : MBColorName.risGrey2.color
		let attributes: [NSAttributedString.Key: Any] = [
			NSAttributedString.Key.foregroundColor: color
		]
		
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
														attributes: attributes)
        self.floatingPlaceholderLabel.attributedText = self.attributedPlaceholder
    }

	
    // MARK: - User Interaction

    @objc func handleTextChange() {

		guard self.showPlaceholderAfterInputText else {
			return
		}
		
        if let text = self.text, text.count >= 1 {
			
            self.placeholderTopConstraint.constant = Constants.floatingLabelTopPositon(for: self.frame, postion: .top)
            UIView.animate(withDuration: Constants.animationDuration) {
				
                self.floatingPlaceholderLabel.alpha = 1
                self.layoutIfNeeded()
            }
        } else if let text = self.text, text.count == 0 {
			
            self.placeholderTopConstraint.constant = Constants.floatingLabelTopPositon(for: self.frame, postion: .center)
            UIView.animate(withDuration: Constants.animationDuration) {
				
                self.floatingPlaceholderLabel.alpha = 0
                self.layoutIfNeeded()
            }
        }
    }
	
	@objc func rightButtonTapped() {
		self.rightButtonAction?()
	}
	

    // MARK: - Insets

    fileprivate func insetRect(for bounds: CGRect) -> CGRect {

        let unfilledRectInsets = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: Constants.textPadding.right)
        let filledRectInsets = UIEdgeInsets(top: Constants.textPadding.top, left: 0, bottom: 0, right: Constants.textPadding.right)

        let insetRect = CGRect(x: self.leftPadding, y: bounds.origin.y, width: bounds.width - self.leftPadding, height: bounds.height)

		guard self.attributedPlaceholder?.string != nil else {
            return insetRect.inset(by: unfilledRectInsets)
        }

        if self.text!.isEmpty {
            return insetRect.inset(by: unfilledRectInsets)
        } else {
            return insetRect.inset(by: filledRectInsets)
        }
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return self.insetRect(for: bounds)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.placeholderRect(forBounds: bounds)
		
		let rightViewWidth = self.rightView?.bounds.width ?? 0
		let width = rect.width - rightViewWidth
        return CGRect(x: self.leftPadding, y: rect.origin.y, width: width, height: rect.height)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.insetRect(for: bounds)
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
		var rect = super.rightViewRect(forBounds: bounds)
		
        rect.origin.x -= Constants.rightViewPadding.right
        return rect
    }
	
	
	// MARK: - Helper
	
    private func addErrorLabel() {
        
        guard self.errorLabel.superview == nil,
            let viewController = self.viewController() else {
                return
        }
        
        viewController.view.addSubview(self.errorLabel)
        self.errorLabel.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            self.errorLabel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 8),
            self.errorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.padding),
            self.errorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.padding)
        ])
    }
    
	func addRightView(with image: UIImage, color: UIColor?, action: RightButtonAction?) {
		
		self.rightButtonAction = action
		
		let buttonSize = CGSize(width: 25, height: 25)
		let button = UIButton(frame: CGRect(origin: .zero, size: buttonSize))
		button.addTarget(self, action: #selector(self.rightButtonTapped), for: .touchUpInside)
		button.isUserInteractionEnabled = action != nil
		button.setImage(image, for: .normal)
		if let color = color {
			button.tintColor = color
		}
        button.translatesAutoresizingMaskIntoConstraints = false

        let line = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 20))
        line.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        line.translatesAutoresizingMaskIntoConstraints = false

        let spacer = UIView(frame: CGRect.zero)
        spacer.backgroundColor = .clear

        let container = UIStackView(arrangedSubviews: [
			spacer,
			line,
			button
		])
        container.alignment = .fill
        container.axis = .horizontal
        container.distribution = .fill
        container.spacing = 16
		
        NSLayoutConstraint.activate([
			button.heightAnchor.constraint(equalToConstant: buttonSize.height),
			button.widthAnchor.constraint(equalToConstant: buttonSize.width),
            line.widthAnchor.constraint(equalToConstant: 1),
            spacer.widthAnchor.constraint(equalToConstant: 4)
            ])
		
		self.rightView = container
        self.rightViewMode = .always
	}
	
	private func resetMandatoryView() {
		
		self.hasMandatoryStyle = false
        self.errorLabel.text = nil
        self.errorLabel.removeFromSuperview()
	}
}


// MARK: - UITextFieldDelegate

extension MBTextField: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return self.mbDelegate?.textFieldShouldBeginEditing?(self) ?? true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

        self.mbDelegate?.textFieldDidBeginEditing?(self)
		self.applyAttributedPlaceholderText()
		self.setEditStyle()
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return self.mbDelegate?.textFieldShouldEndEditing?(self) ?? true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

        self.mbDelegate?.textFieldDidEndEditing?(self)
		self.applyAttributedPlaceholderText()
		
		self.setNormalStyle()
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {

        self.mbDelegate?.textFieldDidEndEditing?(self, reason: reason)
		self.applyAttributedPlaceholderText()
		
		self.setNormalStyle()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return self.mbDelegate?.textField?(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return self.mbDelegate?.textFieldShouldClear?(self) ?? true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return self.mbDelegate?.textFieldShouldReturn?(self) ?? true
    }
}
