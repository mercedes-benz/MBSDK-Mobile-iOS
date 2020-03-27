//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

class MBSnackBarView: UIView {

	// MARK: - Type Definition

    typealias ActionHandler = () -> Void
    typealias Message = String
    
    
    /// Defines where the button should be displayed in the snackbar
    enum ButtonPosition {
        
        /// Display the button on the right side of the Snackbar.
        case right
        /// Display the button at the bottom right of the Snackbar.
        case bottomRight
    }
    
    /// Defines presets for how long the snackbar should be displayed
    enum DurationPresets: TimeInterval {
        
        /// Show the Snackbar for a short period of time.
        case short = 1.500
        /// Show the Snackbar for a long period of time.
        case long = 2.75
        /// Show the Snackbar indefinitely.
        case indefinite = -1
    }
    
    /// Defines the position of the Snackbar, if it is at the top or bottom of the screen
    enum DisplayPosition {
        
        /// Display the Snackbar at the bottom of the view.
        case bottom
        /// Display the Snackbar at the top of the view.
        case top
    }
    

	// MARK: - Struct
	
	private struct Constants {
		
		static let buttonHeight: CGFloat = 36.0
		static let defaultDelay = 0.5
		static let padding: CGFloat = 12.0
	}

	// MARK: - Properties

	private lazy var hStackView: UIStackView = {
		let stack = UIStackView(frame: .zero)
        stack.axis = .horizontal
		stack.spacing = 16.0
		return stack
	}()

	private lazy var vStackView: UIStackView = {
		let stack = UIStackView(frame: .zero)
		stack.axis = .vertical
		return stack
	}()

	private lazy var titleLabel: MBBody2Label = {
		let label = MBBody2Label()
		label.commonInit()
		label.numberOfLines = 0
		label.attributedText = self.getAttributedText()
		label.textColor = .black
		return label
	}()

	private var actionButton: MBBaseButton!
    
    private var animationDuration = 0.3
    private var displayPosition: DisplayPosition = .bottom
    private var hideTimer: Timer?
    private var iconContainerView: UIView?
    private var snackBarWindow: PassthroughWindow?
    private var text: String = ""
    private var visibleDuration: DurationPresets = .long
	
	// MARK: - Public
	
	/// Hide a snackBarView on the bottom of the screen
	///
	/// View will be removed automatically
	///
	/// - Parameters:
	///   - animationDuration: duration of the show- and hide-animation, default == 0.3
	func hide(animationDuration: Double = 0.3) {
		self.hide(duration: animationDuration, delay: 0)
	}
    
    /// Show a snackBarView on the bottom of the screen
    ///
    /// View will be added automatically
    ///
    /// - Parameters:
    ///   - message: text to display
    ///   - visibleDuration: duration of the visible on-screen time, default == .short (1.5 seconds)
    ///   - animationDuration: duration of the show- and hide-animation, default == 0.3
    ///   - displayPosition: position where the snackbar should be displayed, e.g. top or bottom, default == bottom
    class func show(with message: Message, visibleDuration: DurationPresets = .short, animationDuration: Double = 0.3, displayPosition: DisplayPosition = .bottom) {

        let snackBarView = MBSnackBarView.create(with: message, visibleDuration: visibleDuration, animationDuration: animationDuration, displayPosition: displayPosition)
        snackBarView.show()
    }
    
    /// Creates a Snackbar
    ///
    /// - Parameters:
    ///   - message: text to display
    ///   - visibleDuration: duration of the visible on-screen time, default == .short (1.5 seconds)
    ///   - animationDuration: duration of the show- and hide-animation, default == 0.3
    ///   - displayPosition: position where the snackbar should be displayed, e.g. top or bottom, default == bottom
    /// - Returns: instance of MBSnackBarView
    static func create(with message: Message, visibleDuration: DurationPresets = .short, animationDuration: Double = 0.3, displayPosition: DisplayPosition = .bottom) -> MBSnackBarView {
        
        let snackBarView = MBSnackBarView(text: message)
        snackBarView.animationDuration = animationDuration
        snackBarView.displayPosition = displayPosition
        snackBarView.visibleDuration = visibleDuration
        
        return snackBarView
    }
    
    /// Set the icon of the Snackbar
    ///
    /// - Parameters:
    ///   - image: image for icon
    ///   - tintColor: color of icon, default == .black
    func setIcon(with image: UIImage, tintColor: UIColor = .black) {
        
        self.iconContainerView?.removeFromSuperview()
        let imageView = UIImageView(image: image)
        imageView.tintColor = tintColor
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageContainerView = UIView(frame: .zero)
        imageContainerView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageContainerView.widthAnchor.constraint(equalTo: imageView.widthAnchor),
            imageContainerView.heightAnchor.constraint(greaterThanOrEqualTo: imageView.heightAnchor, multiplier: 1)
            ])
        
        self.iconContainerView = imageContainerView
        self.hStackView.insertArrangedSubview(imageContainerView, at: 0)
    }
    
    /// Set the button of the Snackbar
    ///
    /// - Parameters:
    ///   - buttonTitle: title for button
    ///   - buttonPosition: position for button, default == .right
    ///   - actionClosure: action handler to do something
    func setAction(buttonTitle: String, buttonPosition: ButtonPosition = .right, actionClosure: @escaping ActionHandler) {
        
        self.addButton(title: buttonTitle, position: buttonPosition)
        self.actionButton.didTouchUpInside { [unowned self] in
            
            actionClosure()
            self.hide(duration: self.animationDuration, delay: 0)
        }
    }
    
    /// Show a snackBarView on the bottom of the screen
    /// Hides it again if the visibleDuration is not indefinite
    func show() {
        
        self.layout()
        
        // show
        self.show(duration: self.animationDuration, delay: Constants.defaultDelay)
        
        // hide
        if self.visibleDuration != .indefinite {
            self.hide(duration: self.animationDuration, delay: self.visibleDuration.rawValue)
        }
    }
	
	// MARK: - Lifecycle
    
    deinit {
        LOG.V()
    }
	
	private init(text: String) {
        super.init(frame: .zero)
		
        self.text = text
		self.setupUI()
	}
    
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: - Helper
	
	private func addSwipeGesture() {
		
		let swipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(_:)))
		self.addGestureRecognizer(swipeGestureRecognizer)
	}
    
    private func addWindow() {
        
        guard self.snackBarWindow == nil else {
            return
        }
        
        self.snackBarWindow = PassthroughWindow(frame: UIScreen.main.bounds)
        self.snackBarWindow?.windowLevel = UIWindow.Level.alert + 1
        self.snackBarWindow?.isHidden = false
    }
	
    private func constraint(for view: UIView) -> NSLayoutConstraint {
        
        let padding = self.padding(for: view)

        switch self.displayPosition {
        case .bottom:
            guard #available(iOS 11.0, *) else {
                return self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -1 * padding)
            }
            
            return self.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -1 * padding)
            
        case .top:
            guard #available(iOS 11.0, *) else {
                return self.topAnchor.constraint(equalTo: view.topAnchor, constant: padding)
            }
            
            return self.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding)
        }
    }
    
	private func padding(for view: UIView) -> CGFloat {
		
		if #available(iOS 11.0, *) {
                    
            switch self.displayPosition {
            case .bottom:   return view.safeAreaInsets.bottom.isZero ? Constants.padding : 0
            case .top:      return Constants.padding
            }
		} else {
			return Constants.padding
		}
	}
	
    private func safeArea(for view: UIView) -> CGFloat {
		
		if #available(iOS 11.0, *) {
            
            switch self.displayPosition {
            case .bottom:   return view.safeAreaInsets.bottom
            case .top:      return view.safeAreaInsets.top
            }
		} else {
			return 0
		}
	}
	
	private func transform(for view: UIView) -> CGAffineTransform {
        
        var originY: CGFloat {
            
            let originY = self.bounds.height + self.safeArea(for: view) + self.padding(for: view)
            
            switch self.displayPosition {
            case .bottom:   return originY
            case .top:      return -1 * originY
            }
        }
        
        return CGAffineTransform(translationX: 0, y: originY)
	}
	
	private func hide(duration: Double, delay: Double) {
		
        // Timer for delaying the animation
        self.hideTimer?.invalidate()
        self.hideTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false, block: { (_) in
			
			guard let view = self.superview else {
				return
			}
			
            // hide
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
				self.transform = self.transform(for: view)
            }, completion: { (_) in
                self.removeSnackbar()
            })
        })
	}
	
	private func layout() {
        
        self.addWindow()
        		
        guard let window = self.snackBarWindow else {
            return
        }
        
		window.addSubview(self)
		
		self.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
            self.constraint(for: window),
			self.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -1 * Constants.padding),
			self.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: Constants.padding)
			])
		
		self.layoutIfNeeded()
		self.transform = self.transform(for: window)
	}
    
    private func removeSnackbar() {
        
        self.removeFromSuperview()
        self.snackBarWindow?.isHidden = true
        self.snackBarWindow = nil
    }
    
	private func setupUI() {
        
		self.backgroundColor = MBColorName.risWhite.color
		self.layer.borderColor = MBColorName.risGrey3.color.cgColor
		self.layer.borderWidth = 1
		self.layer.cornerRadius = 10

		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowOpacity = 0.12
		self.layer.shadowOffset = CGSize(width: 0, height: 2)
		self.layer.shadowRadius = 4

		self.actionButton = MBPrimaryTextButton(type: .custom)

		self.hStackView.addArrangedSubview(self.titleLabel)
		self.vStackView.addArrangedSubview(self.hStackView)
        self.addSubview(self.vStackView)
		
        self.vStackView.translatesAutoresizingMaskIntoConstraints = false
        
		NSLayoutConstraint.activate([
            self.vStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1 * Constants.padding),
			self.vStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -1 * Constants.padding),
			self.vStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.padding),
			self.vStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.padding),
            self.hStackView.widthAnchor.constraint(equalTo: self.vStackView.widthAnchor, multiplier: 1)
			])
        
        self.addSwipeGesture()
	}

    private func show(duration: Double, delay: Double) {
        
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseInOut, animations: {
            self.transform = .identity
        }, completion: nil)
    }
    
    private func addButton(title: String, position: ButtonPosition) {
        
        self.actionButton.setTitle(title, for: .normal)
        self.actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        switch position {
        case .right:
            self.hStackView.addArrangedSubview(self.actionButton)
            NSLayoutConstraint.activate([
                self.actionButton.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.buttonHeight),
                self.actionButton.widthAnchor.constraint(equalToConstant: self.actionButton.intrinsicContentSize.width + 2 * Constants.padding)
                ])
            
        case .bottomRight:
            let buttonContainerView = UIView(frame: .zero)
            buttonContainerView.addSubview(self.actionButton)
            self.vStackView.addArrangedSubview(buttonContainerView)
            
            NSLayoutConstraint.activate([
				buttonContainerView.heightAnchor.constraint(equalTo: self.actionButton.heightAnchor),
                self.actionButton.centerYAnchor.constraint(equalTo: buttonContainerView.centerYAnchor),
				self.actionButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
				self.actionButton.widthAnchor.constraint(equalToConstant: self.actionButton.intrinsicContentSize.width + 2 * Constants.padding),
                self.actionButton.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor)
                ])
        }
    }
    
    private func getAttributedText() -> NSAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        let attributedText = NSMutableAttributedString(string: self.text)
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
        
        return attributedText
    }
    
    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {

        self.hideTimer?.invalidate()
        
        // Return if the user wants to swipe to far on the left side
        let translation = sender.translation(in: self)
        guard self.frame.origin.x + translation.x > Constants.padding else {
            return
        }
        
        self.center = CGPoint(x: self.center.x + translation.x, y: self.center.y)
        sender.setTranslation(.zero, in: self)
        
        if sender.state == .ended {
            
            let velocity = sender.velocity(in: self).x
            
            // Hide view if the user swipe very fast or over 40% of the views width
            if  velocity > 1000 || self.frame.origin.x > self.frame.width * 0.4 {
                
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                    self.transform = CGAffineTransform(translationX: self.bounds.width * 2, y: 0)
                }, completion: { (_) in
                    self.removeSnackbar()
                })
            } else {
                
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                    self.frame.origin.x = Constants.padding
                }, completion: { (_) in
                    
                    if self.visibleDuration != .indefinite {
                        self.hide(duration: self.animationDuration, delay: self.visibleDuration.rawValue)
                    }
                })
            }
        }
    }
}
