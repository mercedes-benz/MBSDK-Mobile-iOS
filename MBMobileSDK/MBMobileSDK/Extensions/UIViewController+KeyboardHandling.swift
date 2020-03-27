//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

struct AssociatedKeys {
    static var managedScrollView: UInt8 = 0
    static var managedVisibleRect: UInt8 = 1
}


extension UIViewController {

    // MARK: - Properties
    
    private (set) var managedScrollView: UIScrollView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.managedScrollView) as? UIScrollView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.managedScrollView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    private (set) var managedVisibleRect: CGRect? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.managedVisibleRect) as? CGRect
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.managedVisibleRect, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    
    // MARK: - Observer
    
    /// Enables the keyboard handling, adds observer etc
    ///
    /// - Parameters:
    ///   - scrollView: Scrollview that will be affected by the keyboard
    ///   - visibleRect: The Rect that should be visible when the keyboard will be shown
    func mbEnableKeyboardHandler(scrollView: UIScrollView, visibleRect: CGRect? = nil) {

        self.managedScrollView = scrollView
        self.managedVisibleRect = visibleRect
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func mbDisableKeyboardHandler() {
        
        self.managedScrollView = nil
        self.managedVisibleRect = nil
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }


    // MARK: - Keyboard handling
    
    @objc func keyboardWillShow(notification: Notification) {

        guard let scrollView = self.managedScrollView,
			var keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
		
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        let bottomSpace = self.view.bounds.height - scrollView.bounds.height
        
        var contentInset: UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20 - bottomSpace
        scrollView.contentInset = contentInset
        
        if let rect = self.managedVisibleRect {

            DispatchQueue.main.async {
                
                // If the rect is bigger than the visible height of the keyboard, than set the offset
                // scrollRectToVisible moves to the maxY of the rect, not to the minY
                if rect.height > scrollView.frame.height - keyboardFrame.size.height {
                    scrollView.setContentOffset(CGPoint(x: 0, y: rect.minY), animated: true)
                } else {
                    scrollView.scrollRectToVisible(rect, animated: true)
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        self.managedScrollView?.contentInset.bottom = 0
    }
}
