//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Quick
import Nimble

@testable import MBMobileSDK

class PinValidationModelTests: QuickSpec {
    
    override func spec() {
    
        describe("parameters") {
            it("should include the pin if not nil") {
                let model = PinValidationModel(biometricAuthenticationEnabled: true, pin: "aPin")
                expect(model.parameters["pin"] as? String) == "aPin"
            }
            
            it("should not include the pin if it is nil") {
                let model = PinValidationModel(biometricAuthenticationEnabled: true, pin: nil)
                expect(model.parameters.index(forKey: "pin")).to(beNil())
            }
            
            it("should include action enabled if biometricAuthenticationEnabled is true") {
                let model = PinValidationModel(biometricAuthenticationEnabled: true)
                expect(model.parameters["action"] as? String) == "enabled"
            }
            
            it("should include action disabled if biometricAuthenticationEnabled is false") {
                let model = PinValidationModel(biometricAuthenticationEnabled: false)
                expect(model.parameters["action"] as? String) == "disabled"
            }
        }
    }
}
