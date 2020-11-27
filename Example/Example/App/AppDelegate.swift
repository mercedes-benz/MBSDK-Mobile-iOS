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
        
        let clientId = "app"
        let config = MBMobileSDKConfiguration(applicationIdentifier: "example",
                                              authenticationConfigs: [
                                                ROPCAuthenticationConfig(clientId: clientId, type: .keycloak),
                                                ROPCAuthenticationConfig(clientId: clientId, type: .ciam)
                                              ],
                                              endpoint: MBMobileSDKEndpoint(region: .ece,
                                                                            stage: .prod),
                                              preferredAuthMethod: .keycloak)
        MobileSDK.setup(configuration: config)
        MobileSDK.usePinProvider(pinProvider: ExamplePinProvider())
        
        return true
    }
}
