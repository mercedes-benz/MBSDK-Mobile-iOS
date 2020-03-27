//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

extension UIApplication {
	
    /// Return the top most viewController from the appDelegate include UIAlertViewController
    func topViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topViewController()
    }
}

extension UIViewController {
	
	/// Return the top most viewController
	func topViewController() -> UIViewController {
		
		guard let presentedViewController = self.presentedViewController else {
			return self
		}
		
		if let navigationViewController = presentedViewController as? UINavigationController {
			
			guard let visibleViewController = navigationViewController.visibleViewController else {
				return navigationViewController.topViewController()
			}
			
			return visibleViewController.topViewController()
		}
		
		if let tabBarController = presentedViewController as? UITabBarController {
			
			guard let selectedViewController = tabBarController.selectedViewController else {
				return tabBarController.topViewController()
			}
			
			return selectedViewController.topViewController()
		}
		
		return presentedViewController.topViewController()
	}
}
