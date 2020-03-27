//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Load view from nib as class func
    ///
    /// loads xib-file from main bundle
	class func mbLoadFromNib<T: UIView>() -> T {
        return mbLoadFromNib(with: Bundle.main)
    }

    /// Load view from nib as class func
    ///
    /// loads xib-file from a given Bundle
	class func mbLoadFromNib<T: UIView>(with bundle: Bundle) -> T {

        let nibName: String = String(describing: T.self)

        guard let view = bundle.loadNibNamed(nibName, owner: nil, options: nil)?.first as? T else {
			fatalError("UIView \(T.self) isn't in \(String(describing: bundle.bundleIdentifier)) bundle")
        }

        return view
    }
    
    /// Loads with from nib (if avaiable)
    ///
    /// loads xib-file from current bundle
    @objc func mbLoadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        
        guard bundle.path(forResource: String(describing: type(of: self)), ofType: "nib") != nil else {
            return
        }
        
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.addSubview(view)
        }
    }
}
