//
// Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit
import MBCommonKit
import MBMobileSDK

let LOG = MBLogger.shared

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let config = MBMobileSDKConfiguration(applicationIdentifier: "example",
											  clientId: "app",
											  endpoint: MBMobileSDKEndpoint(region: .ece,
                                                                            stage: .prod))
        MobileSDK.setup(configuration: config)
		
        return true
    }
}
