//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public struct PinValidationModel: Encodable {

    let pin: String?
    
    let biometricAuthenticationEnabled: Bool

    var parameters: [String: Any] {

        var parameters: [String: Any] = [:]
        if let pin = self.pin {
            parameters["pin"] = pin
        }
        parameters["action"] = self.biometricAuthenticationEnabled ? "enabled" : "disabled"
        return parameters
    }

    public init(biometricAuthenticationEnabled: Bool, pin: String? = nil) {
        
        self.pin = pin
        self.biometricAuthenticationEnabled = biometricAuthenticationEnabled
    }
}
