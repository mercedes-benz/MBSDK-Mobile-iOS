//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

typealias MBDialogueCompletion = (_ buttonTitle: String?) -> Void

class MBDialogueController: UIViewController {

	private struct Constants {

		static let maxHorrizontalElements = 2
	}

    enum MBDialogueType {

        case alert(message: String)
        case custom(view: UIView)
        case error(errorMessage: String)
    }

    enum CloseButtonOption {

        case left
        case right
        case none
    }

    // MARK: - Outlets

	@IBOutlet private weak var buttonContainerShadowView: UIView!
	@IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var leftCloseButton: UIButton!
    @IBOutlet private weak var rightCloseButton: UIButton!
	@IBOutlet private weak var titleLabel: MBHeadlineSerif5Label!
    @IBOutlet private weak var backdropView: UIView!
    @IBOutlet private weak var titleView: UIView!
    @IBOutlet private weak var contentContainerStackView: UIStackView!
    @IBOutlet private weak var buttonContainerView: UIStackView!
    @IBOutlet private weak var windowView: UIView!

    // MARK: - Properties
    
    open var useAlwaysVertical: Bool = false {
        didSet {
            self.handleUseAlwaysVertical()
        }
    }
    
    open var backdropAlpha: CGFloat {
        get {
            return self.backdropView.alpha
        }
        set {
            self.backdropView.alpha = newValue
        }
    }

    open var backdropColor: UIColor = .black {
        didSet {
            self.backdropView.backgroundColor = self.backdropColor
        }
    }

    open var closeButtonOption: CloseButtonOption = .right {
        didSet {
            self.handleCloseButtonOption()
        }
    }

    open var cornerRadius: CGFloat {
        get {
            return self.windowView.layer.cornerRadius
        }
        set {
            self.windowView.layer.cornerRadius = newValue
            self.shadowView.layer.cornerRadius = newValue
        }
    }

    open var borderColor: UIColor? {
        get {
            if let color = self.windowView.layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            self.windowView.layer.borderColor = newValue?.cgColor
        }
    }

    private lazy var alertView: MBAlertContentView = {
        return MBAlertContentView.mbLoadFromNib(with: Bundle(for: MBAlertContentView.self))
    }()
    
    private lazy var errorView: MBErrorView = {
        return MBErrorView.mbLoadFromNib(with: Bundle(for: MBErrorView.self))
    }()


    // MARK: - View Lifecycle

	deinit {
		LOG.V()
	}
	
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
		
        self.shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds.insetBy(dx: 4, dy: 4)).cgPath
    }


    // MARK: - Initializer

    static func create(for type: MBDialogueType, with title: String) -> MBDialogueController {
		
        let vc = MBDialogueController(nibName: "MBDialogueController", bundle: Bundle(for: MBDialogueController.self))
        vc.setup(with: type, title)
        return vc
    }


    // MARK: - Interface

	private func addTopBorder(to btn: MBBaseButton) {

        let topBorder = MBSeparatorView(frame: .zero)
		topBorder.translatesAutoresizingMaskIntoConstraints = false
		btn.addSubview(topBorder)

		NSLayoutConstraint.activate([
			topBorder.heightAnchor.constraint(equalToConstant: 1/UIScreen.main.scale),
			topBorder.leadingAnchor.constraint(equalTo: btn.leadingAnchor),
			topBorder.trailingAnchor.constraint(equalTo: btn.trailingAnchor),
			topBorder.topAnchor.constraint(equalTo: btn.topAnchor)
			])
	}

	func addButton(with title: String, style: UIAlertAction.Style = .default, action: @escaping (() -> Void)) -> MBBaseButton {

		let titleColor: UIColor

		switch style {
		case .destructive, .cancel:
			titleColor = MBColorName.risGrey2.color
		default:
			titleColor = MBColorName.risAccentPrimary.color
		}

        let btn = MBBaseButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.apply(style: .button1())
        btn.backgroundColor = .clear
		btn.setTitleColor(titleColor, for: .normal)
        btn.setTitleColor(titleColor.withAlphaComponent(0.7), for: .highlighted)
        btn.accessibilityIdentifier = "dialogue_button_other_\(self.buttonContainerView.arrangedSubviews.count)"
		btn.didTouchUpInside { [unowned self] in

			self.dismiss(animated: true, completion: action)
		}

		NSLayoutConstraint.activate([
			btn.heightAnchor.constraint(equalToConstant: 52)
			])

		if !self.buttonContainerView.arrangedSubviews.isEmpty {
			self.addTopBorder(to: btn)
		}

		self.buttonContainerView.isHidden = false
		self.buttonContainerView.addArrangedSubview(btn)

		if self.buttonContainerView.arrangedSubviews.count > Constants.maxHorrizontalElements || self.useAlwaysVertical {

			self.buttonContainerView.axis = .vertical
		}
		
		return btn
    }

    private func addButtonContainerSeparator() {
        
        let separatorView = MBSeparatorView(frame: .zero)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        self.buttonContainerShadowView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalToConstant: 1/UIScreen.main.scale),
            separatorView.leadingAnchor.constraint(equalTo: self.buttonContainerView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: self.buttonContainerView.trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: self.buttonContainerView.topAnchor)
            ])
    }
    
    private func applyDropShadow(with color: Color, radius: CGFloat, offset: CGSize = CGSize.zero, alpha: Float = 1.0) {

        self.shadowView.layer.shadowColor = color.cgColor
        self.shadowView.layer.shadowOffset = offset
        self.shadowView.layer.shadowRadius = radius
        self.shadowView.layer.shadowOpacity = alpha
        self.shadowView.clipsToBounds = false
        self.shadowView.layer.masksToBounds = false
        self.shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
    }


    // MARK: - Private Interface

    private func setup(with type: MBDialogueType, _ title: String) {

        // Do any additional setup after loading the view.

        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        self.view.backgroundColor = .clear
        self.cornerRadius = 10
        self.closeButtonOption = .right
        self.backdropAlpha = 0.7
        self.applyDropShadow(with: MBColorName.risBlack.color, radius: 6, alpha: 0.7)
        
        self.rightCloseButton.accessibilityIdentifier = "dialogue_close_right"
        self.leftCloseButton.accessibilityIdentifier = "dialogue_close_left"
        
        switch type {
        case .alert(let message):       self.setupAlertType(with: message)
        case .custom(let view):         self.setupCustomType(with: view)
        case .error(let errorMessage):  self.setupErrorType(with: errorMessage)
        }
        
        self.addButtonContainerSeparator()

        self.titleLabel.text = title
    }

    private func setupAlertType(with message: String) {

        self.closeButtonOption = .none
        self.alertView.contentTextLabel.text = message
        self.contentContainerStackView.insertArrangedSubview(self.alertView, at: 0)
    }

    private func setupCustomType(with view: UIView) {

        self.contentContainerStackView.insertArrangedSubview(view, at: 0)
    }
    
    private func setupErrorType(with errorMessage: String) {
        
        self.closeButtonOption = .none
        self.errorView.configure(errorMessage: errorMessage)
        self.contentContainerStackView.insertArrangedSubview(self.errorView, at: 0)
    }

    private func handleCloseButtonOption() {

        switch self.closeButtonOption {
        case .left:
            self.rightCloseButton.isHidden = true
            self.leftCloseButton.isHidden = false
			
        case .right:
            self.rightCloseButton.isHidden = false
            self.leftCloseButton.isHidden = true
			
        case .none:
            self.rightCloseButton.isHidden = true
            self.leftCloseButton.isHidden = true
        }
    }
    
    private func handleUseAlwaysVertical() {
        
        let shouldUseVertical = self.buttonContainerView.arrangedSubviews.count > Constants.maxHorrizontalElements || self.useAlwaysVertical
        self.buttonContainerView.axis = shouldUseVertical ? .vertical : .horizontal
    }


    // MARK: - User Interaction

    @IBAction func closeButtonTouched(_ sender: Any) {
        self.dismiss(animated: true) {
        }
    }
}
