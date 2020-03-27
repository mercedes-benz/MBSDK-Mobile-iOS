//
// Copyright (c) 2020 MBition GmbH. All rights reserved.
//

import UIKit
import MBCommonKit
import MBIngressKit
import MBNetworkKit

open class NativeLoginViewController: BaseLoginViewController, LoginWorkflowHandling {

    private struct Constants {
        static let animationDuration = 0.1
        static let buttonRadius: CGFloat = 10
    }
    
    // MARK: - Lazy
    
    private lazy var gradientRect: CGRect = {

        let point = CGPoint(x: self.view.bounds.origin.x, y: self.view.bounds.height - self.view.bounds.height / 2)
        let size = CGSize(width: self.view.bounds.width, height: self.view.bounds.height / 2)
        return CGRect(origin: point, size: size)
    }()

    private lazy var backgroundLayer: CAGradientLayer = {

        let backgroundLayer = CAGradientLayer()
        backgroundLayer.frame = self.gradientRect
        backgroundLayer.colors = [
            MBColorName.risBlack.color.cgColor,
            UIColor.clear.cgColor
        ]
        backgroundLayer.locations = [
            0.25
        ]
        backgroundLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        backgroundLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        return backgroundLayer
    }()


    // MARK: - IBOutlet

    @IBOutlet private weak var headerLabel: MBHeadlineSerif4Label! {
        didSet {
            self.headerLabel.apply(style: .emphasized(.low))
            self.headerLabel.text = L10n.Localizable.loginMercedesmeId
        }
    }
    @IBOutlet private weak var captionLabel: MBHeadlineSerif5Label! {
        didSet {
            self.captionLabel.apply(style: .emphasized(.low))
            self.captionLabel.numberOfLines = 0
            self.captionLabel.text = L10n.Localizable.loginOnlyCaption
        }
    }
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var textField: MBTextField!
    @IBOutlet private weak var sendButton: MBPrimaryButton!
    @IBOutlet private weak var mercedesMeIDButton: MBBaseButton! {
        didSet {
            let image = MBImageName.infoFilled.image.withRenderingMode(.alwaysTemplate)

            self.mercedesMeIDButton.setImage(image, for: .normal)
            self.mercedesMeIDButton.imageView?.layer.cornerRadius = Constants.buttonRadius
            self.mercedesMeIDButton.didTouchUpInside { [weak self] in
                self?.didTapMercedesMeButton()
            }
        }
    }
    
    // MARK: - Properties
	
    private weak var delegate: LoginWorkflowHandling?

	
	// MARK: - Instatiation
    
    static func instantiate() -> UIViewController {
        return StoryboardScene.Login.nativeLoginViewController.instantiate()
    }
	
	
    // MARK: - View Lifecycle

    deinit {
        LOG.V()
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleGesture))
        self.view.addGestureRecognizer(tapGesture)
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let buttonRect = self.sendButton.convert(self.sendButton.bounds, to: self.scrollView)
        self.mbEnableKeyboardHandler(scrollView: self.scrollView, visibleRect: buttonRect)
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.backgroundLayer.frame = self.gradientRect
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.mbDisableKeyboardHandler()
    }
    

    // MARK: - Setup

    override func setupUI() {
        super.setupUI()

        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.view.layer.insertSublayer(self.backgroundLayer, below: self.scrollView.layer)
        self.scrollView.delegate = self

        self.textField.mbDelegate = self
        self.textField.placeholder = L10n.Localizable.loginUsername
        self.textField.autocorrectionType = .no
        self.textField.keyboardType = .emailAddress
        self.textField.returnKeyType = .next
        self.textField.addTarget(self, action: #selector(self.textFieldDidChanged), for: .editingChanged)

        self.sendButton.isEnabled = false
        self.sendButton.setTitle(L10n.Localizable.loginNext, for: .normal)
        self.sendButton.didTouchUpInside { [weak self] in
            self?.didTapNextButton()
        }
    }

    override func setupAccessibility() {
        super.setupAccessibility()

        self.textField.accessibilityIdentifier = L10n.IdentifierUI.loginTextfield
        self.sendButton.accessibilityIdentifier = L10n.IdentifierUI.loginButtonNext
    }

	
    // MARK: - Gesture handling
	
    @objc private func handleGesture() {
        (self.view.firstResponder as? UITextField)?.resignFirstResponder()
    }


    // MARK: - Button Actions

    func didTapNextButton() {

        guard let username = self.textField.text, username.isEmpty == false else {
            return
        }

        let trimUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard ValidationHelper.isValid(mail: trimUsername) || ValidationHelper.isValid(phone: trimUsername) else {
            AlertHelper.showOK(from: self, type: .hint(message: L10n.Localizable.loginInvalidInput))
            return
        }

        self.processLogin(username: trimUsername)
    }

    func didTapMercedesMeButton() {
        AlertHelper.showOK(from: self, type: .default(title: L10n.Localizable.loginInfoAlertTitle, message: L10n.Localizable.loginInfoAlertMessage))
    }


    // MARK: - Request Handling

    private func processLogin(username: String) {

        self.sendButton.activate(state: .loading)
        IngressKit.userService.existUser(username: username) { [weak self] (result) in

            self?.sendButton.activate(state: .interactable)

            switch result {
            case .failure(let error):
                self?.handleError(error: MBError(description: error.description, type: .unknown))

            case .success(let userExistModel):
                self?.delegate?.handleSuccess(user: userExistModel, credential: username)
            }
        }
    }
    
	
    // MARK: - LoginWorkflow handling
    
    func handleError(error: MBError) {
		AlertHelper.showOK(from: self, type: .error(error))
	}
       
    open func handleSuccess(user: UserExistModel, credential: String) {
		
		// user is not available and has to register, will be processed with the type
		if user.username.isEmpty {
			AlertHelper.showOK(from: self, type: .hint(message: L10n.Localizable.loginUserNotRegistered), completion: nil)
		} else {
			
			// user is already registered and has to verify with pin
			let credentialType: PinVerifyCredentialType = user.isEmail ? .mail(account: user.username) : .phone(number: user.username)
			let vc = VerifyPinViewController.instantiate(verificationType: credentialType)
			self.navigationController?.pushViewController(vc, animated: true)
		}
    }
    
    // MARK: - Helper
    
    public func resetTextField() {

        self.textField.text = ""
        self.textField.becomeFirstResponder()
    }
    
    public func setCaption(_ caption: String) {
        self.captionLabel.text = caption
    }
}


// MARK: - UITextFieldDelegate

extension NativeLoginViewController: MBTextFieldDelegate {

    func textFieldShouldReturn(_ textField: MBTextField) -> Bool {

        guard textField.text?.isEmpty == false else {
            return false
        }

        textField.resignFirstResponder()
        self.sendButton.sendActions(for: .touchUpInside)
        return true
    }

    @objc func textFieldDidChanged() {
        self.sendButton.isEnabled = self.textField.text?.isEmpty == false
    }
}


// MARK: - UIScrollViewDelegate

extension NativeLoginViewController: UIScrollViewDelegate {

    public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.scrollView.layoutIfNeeded()
        }
    }
}
