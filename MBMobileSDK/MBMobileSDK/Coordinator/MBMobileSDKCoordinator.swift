//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import UIKit

public class MBMobileSDKCoordinator {
        
    /// Returns the login view controller
    public func getLoginViewController() -> UIViewController {
        
        let vc = NativeLoginViewController.instantiate()
        return MBNavigationController(rootViewController: vc)
    }
}
