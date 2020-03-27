//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

protocol MBPinTextFieldDelegate: class {
    
    func pinTextFieldDidDeleteBackward(_ textField: MBPinTextField)
    func pinTextField(_ textField: MBPinTextField, didPastedPin pinItems: [String]?)
}


class MBPinTextField: MBTextField {
    
    // MARK: - UI Constants
    
    enum UIConst {
        static let font = UIFont.systemFont(ofSize: 16)
        static let placeholderFont = UIFont.systemFont(ofSize: 16)
        static let textColor = MBColorName.risGrey0.color
        static let placeholderColor = MBColorName.risGrey3.color
        static let bottomLineColor = MBColorName.risGrey3.color
    }
    
    
    // MARK: - Properties
    
    ///
    weak var customDelegate: MBPinTextFieldDelegate?

    
    // MARK: - Overrides
	
	override var leftPadding: CGFloat {
		return 0
	}
	
	override var showPlaceholderAfterInputText: Bool {
		return false
	}
	
    override func deleteBackward() {
        super.deleteBackward()
		
        self.customDelegate?.pinTextFieldDidDeleteBackward(self)
    }

    override func paste(_ sender: Any?) {

        guard let text = UIPasteboard.general.string?.trimmingCharacters(in: .whitespaces), Double(text) != nil, text.count == 6 else {
            self.customDelegate?.pinTextField(self, didPastedPin: nil)
            return
        }
        let pinItems = Array(text).map({ String($0) })
        self.customDelegate?.pinTextField(self, didPastedPin: pinItems)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds
    }
}
