//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import UIKit

extension UIView {
    
    func viewController() -> UIViewController? {
        
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.viewController()
        }
        
        return nil
    }
}
