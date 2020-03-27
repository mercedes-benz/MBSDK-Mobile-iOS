//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

// MARK: - MBPinView Class

class MBPinView: MBBaseView {

	private struct Constants {
		static let defaults = "-"
	}
	
    // MARK: Properties
    
    /// Defines how many textfields will be generated
    var numberOfDigits: Int = 6 {
        didSet {
            self.addTextFields()
        }
    }
    
    /// Provides the entered PIN
    var pin: String {
		return self.textFields.compactMap { $0.text }.joined()
    }
	
    /// Defines the main part of the accessibility identifier of the pin text field
	var pinFieldAccessibilityIdentifier: String = "" {
		didSet {
			for (index, textField) in self.textFields.enumerated() {
				self.setAccessibilityIdentifier(for: textField, index: index)
			}
		}
	}
	
    /// Returns whether all fields filled properly
    var isAllFilled: Bool {
        return self.pin.replacingOccurrences(of: Constants.defaults, with: "").count == self.numberOfDigits
    }
	
	/// Property for observation handling
	@objc dynamic var isPinInputComplete: Bool = false
	
    /// Indicates whether the pin entry fields should be secure or not
    var isSecureTextEntry: Bool = false {
        didSet {
            self.addTextFields()
        }
    }
    
    private var stackView: UIStackView!
    private var textFields = [UITextField]()
    
    
    // MARK: Responder
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        
        guard let firstTextField = self.textFields.first else {
            return false
        }
        
        return firstTextField.becomeFirstResponder()
    }
    
    override var isFirstResponder: Bool {
        
        for textField in self.textFields where textField.isFirstResponder {
            return true
        }
        
        return false
    }
    
    
    // MARK: Setup UI
    
    override func setupUI() {
        
        self.backgroundColor = .clear
        self.addStackView()
        self.addTextFields()
    }

    func addStackView() {
        
        self.stackView = UIStackView()
        self.stackView.axis = .horizontal
        self.stackView.spacing = 10
        self.stackView.distribution = .fillEqually
        self.addSubview(self.stackView)
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.topAnchor.constraint(equalTo: self.stackView.topAnchor),
			self.bottomAnchor.constraint(equalTo: self.stackView.bottomAnchor),
			self.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor),
			self.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor)
		])
    }

    private func addTextFields() {
        
        self.removeTextFields()
        for index in 0..<self.numberOfDigits {
            
            let textField = MBPinTextField()
			textField.translatesAutoresizingMaskIntoConstraints = false
            textField.keyboardType = .numberPad
            textField.textAlignment = .center
            textField.mbDelegate = self
            textField.isSecureTextEntry = self.isSecureTextEntry
            textField.customDelegate = self
			textField.font = MBTypography.h5Serif.font
			textField.placeholder = "-"
            textField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
			self.setAccessibilityIdentifier(for: textField, index: index)
            self.stackView.addArrangedSubview(textField)
            self.textFields.append(textField)
			NSLayoutConstraint.activate([
				textField.widthAnchor.constraint(equalToConstant: 35),
				textField.heightAnchor.constraint(equalToConstant: 46)
				])
        }
    }

    private func removeTextFields() {
        
        self.textFields.removeAll()
        for subview in self.stackView.arrangedSubviews {
            
            self.stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }

	private func setAccessibilityIdentifier(for textField: UITextField, index: Int) {
		
		textField.isAccessibilityElement = true
		textField.accessibilityIdentifier = self.pinFieldAccessibilityIdentifier + "_\(index)"
	}
	
	
	// MARK: - User Interaction

    @objc func textFieldDidChange(sender: UITextField) {
		
		guard sender.text?.count ?? 0 >= 1 else {
			return
		}
		
		if let index = self.textFields.firstIndex(of: sender), index + 1 < self.numberOfDigits {
			self.textFields.item(at: index + 1)?.becomeFirstResponder()
		} else {
			sender.resignFirstResponder()
		}
    }
}


// MARK: - MBTextField Delegate

extension MBPinView: MBTextFieldDelegate {

	func textFieldShouldBeginEditing(_ textField: MBTextField) -> Bool {
		
        if self.textFields.first == textField {
            return true
        }
        
        if let text = textField.text, text.isEmpty == false {
            return true
        }
        
        if self.isFirstResponder {
            return true
        }
        
        self.becomeFirstResponder()
        return false
    }

    func textFieldDidBeginEditing(_ textField: MBTextField) {
		
		if self.isPinInputComplete == true {
			self.isPinInputComplete = false
		}
		
        textField.text = ""
    }
	
	func textFieldShouldEndEditing(_ textField: MBTextField) -> Bool {
		
		self.isPinInputComplete = self.textFields.last == textField && self.isAllFilled
		return true
	}
	
    func textField(_ textField: MBTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if range.location == 0 && range.length == 0 && string.count == 1 {
            return true
        }
        return false
    }
}


// MARK: - Custom MBTextFiel Delegate

extension MBPinView: MBPinTextFieldDelegate {

    func pinTextField(_ textField: MBPinTextField, didPastedPin pinItems: [String]?) {

        if let pinItems = pinItems {
			
            for (idx, textfield) in self.textFields.enumerated() {
                textfield.text = pinItems.item(at: idx)
            }
            textField.resignFirstResponder()
			
			self.isPinInputComplete = self.isAllFilled
        } else {
			
			self.isPinInputComplete = false
			MBDialogueController.show(from: UIApplication.shared.topViewController(),
									  title: L10n.Localizable.generalHint,
									  message: L10n.Localizable.alertMessageInvalidPin,
									  buttonTitles: [L10n.Localizable.generalOk],
									  completion: nil)
        }
    }
    
    func pinTextFieldDidDeleteBackward(_ textField: MBPinTextField) {
        
        if let index = self.textFields.firstIndex(of: textField), index - 1 >= 0 {
                
            let nextTextField = self.textFields[index - 1]
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }
}
