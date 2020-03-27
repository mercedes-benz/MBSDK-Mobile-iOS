//
// Copyright (c) 2020 MBition GmbH. All rights reserved.
//


import UIKit
import MBCommonKit
import MBIngressKit
import MBNetworkKit

public enum PinVerifyCredentialType {
    case mail(account: String)
    case phone(number: String)
}

open class VerifyPinViewController: UIViewController, VerifyPinWorkflowHandling {

    // MARK: IBOutlet
    @IBOutlet private weak var tanHeadlineSubtitleView: MBHeadlineSubtitleView!
    @IBOutlet private weak var noTanHeadlineSubtitleView: MBHeadlineSubtitleView!
    @IBOutlet private weak var pinView: MBPinView!
    @IBOutlet private weak var sendButton: MBPrimaryButton!
    @IBOutlet private weak var retryButton: MBSecondaryButton!
    @IBOutlet private weak var scrollView: UIScrollView!

    // MARK: Properties
    private var credential: String {

        guard let credentialType = self.credentialType else {
            return ""
        }

        switch credentialType {
        case .mail(let credential),
             .phone(let credential):    return credential
        }
    }
    private var observer: NSKeyValueObservation?
    private var credentialType: PinVerifyCredentialType?

    private weak var delegate: VerifyPinWorkflowHandling?

	
	// MARK: - Instatiation
    
    static func instantiate(verificationType: PinVerifyCredentialType) -> UIViewController {
		
        let viewController = StoryboardScene.Login.verifyPinViewController.instantiate()
        viewController.credentialType = verificationType
        return viewController
    }
	
	
	// MARK: - Public
    
    public func set(credentialType: PinVerifyCredentialType) {
        self.credentialType = credentialType
    }
	
	
    // MARK: - View Lifecycle

    deinit {
        LOG.V()

        self.observer = nil
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self

        self.title = L10n.Localizable.verificationTitle

        self.setupAccessibility()
        self.setupUI()

        self.addKeyValueObserver()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.mbEnableKeyboardHandler(scrollView: self.scrollView)
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.mbDisableKeyboardHandler()
    }
    

    // MARK: - Setup

    private func addKeyValueObserver() {

        self.observer = self.pinView.observe(\.isPinInputComplete, options: [.initial, .new], changeHandler: { [weak self] (_, change) in

            self?.sendButton.isEnabled = change.newValue ?? false

            if change.newValue == true {
                self?.processLogin(pin: self?.pinView.pin)
            }
        })
    }

    private func setupAccessibility() {

        self.pinView.pinFieldAccessibilityIdentifier = L10n.IdentifierUI.verificationPinTextfield

        self.sendButton.isAccessibilityElement = true
        self.sendButton.accessibilityIdentifier = L10n.IdentifierUI.verificationBtnLogin

        self.retryButton.isAccessibilityElement = true
        self.retryButton.accessibilityIdentifier = L10n.IdentifierUI.verificationBtnSendAgain
    }

    private func setupUI() {

        self.view.setBackgroundColor(.risGrey4)

        guard let credentialType = self.credentialType else {
            return
        }

        let bodyText: String = {
            switch credentialType {
            case .mail(let email):    return L10n.Localizable.verificationLoginMsgUser(6, email)
            case .phone(let phone):    return L10n.Localizable.verificationLoginMsgUser(6, phone)
            }
        }()
        let noTanBodyText: String = {
            switch credentialType {
            case .mail:        return L10n.Localizable.verificationNotReceivedHintMail
            case .phone:    return L10n.Localizable.verificationNotReceivedHintPhone
            }
        }()

        self.tanHeadlineSubtitleView.set(headline: L10n.Localizable.verificationHeadline, subtitle: bodyText)
        self.noTanHeadlineSubtitleView.set(headline: L10n.Localizable.verificationNotReceived, subtitle: noTanBodyText)

        self.sendButton.isEnabled = false
        self.sendButton.setTitle(L10n.Localizable.verificationBtnNext, for: .normal)
        self.retryButton.setTitle(L10n.Localizable.verificationBtnSendAgain, for: .normal)

        self.configureButtons()
    }

    private func configureButtons() {

        // send button action
        self.sendButton.didTouchUpInside { [weak self] in
            self?.processLogin(pin: self?.pinView.pin)
        }

        // retry
        self.retryButton.didTouchUpInside { [weak self] in
            self?.retryLogin()
        }
    }
    
	
    // MARK: - Process Login

    private func processLogin(pin: String?) {

        guard let pin = pin,
              self.credential.isEmpty == false else {
                return
        }

        Notification.Name.willLogin.post()

        self.sendButton.activate(state: .loading)
        IngressKit.loginService.login(username: self.credential, pin: pin) { [weak self] (result) in

            self?.sendButton.activate(state: .interactable)

            switch result {
            case .failure(let error):   self?.handle(error: error)
            case .success:              self?.delegate?.handleSuccess()
            }
        }
    }


    // MARK: - Retry

    private func retryLogin() {

        guard self.credential.isEmpty == false else {
            return
        }

        self.retryButton.activate(state: .loading)
        IngressKit.userService.existUser(username: self.credential) { [weak self] (result) in

            self?.retryButton.activate(state: .interactable)

            switch result {
            case .failure(let error):   AlertHelper.showOK(from: self, type: .error(MBError(description: error.description, type: .unknown)))
            case .success:              AlertHelper.showOK(from: self, type: .hint(message: L10n.Localizable.verificationSendAgainMsg))
            }
        }
    }
    
	
    // MARK: - VerifyPinWorkflowHandling
    
    open func handleSuccess() {
        Notification.Name.didLogin.post()
    }
    
    func handle(error: MBError) {
        
        if error.localizedDescription == nil {
            AlertHelper.showOK(from: self, type: .default(title: L10n.Localizable.generalErrorTitle, message: L10n.Localizable.loginErrorAuthenticationFailed))
        } else if error.localizedDescription == "invalid_grant" {
            AlertHelper.showOK(from: self, type: .default(title: L10n.Localizable.generalErrorTitle, message: L10n.Localizable.loginErrorWrongTan))
        } else {
            AlertHelper.showOK(from: self, type: .error(error))
        }
    }
}
