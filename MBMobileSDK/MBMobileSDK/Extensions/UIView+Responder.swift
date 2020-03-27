//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import UIKit

extension UIView {
    
    var firstResponder: UIView? {
        
        guard !isFirstResponder else {
            return self
        }
        
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        
        return nil
    }
}
