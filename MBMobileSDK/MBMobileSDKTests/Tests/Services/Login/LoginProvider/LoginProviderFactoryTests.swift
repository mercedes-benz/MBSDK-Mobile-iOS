//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Quick
import Nimble

import MBCommonKit
@testable import MBMobileSDK

class LoginProviderFactoryTests: QuickSpec {

    override func spec() {
        
        var factory: LoginProviderFactory!
        
        beforeEach() {
            factory = LoginProviderFactory()
        }
        
        describe("buildProviders") {
            it("should build only ROPCAuthenticationProviding providers") {
                let providers = factory.buildProviders(authenticationProviders: [MockSomethingElseProviding()],
                                                       tokenStore: MockTokenStore())
                expect(providers.count) == 0
            }
            
            it("should build ROPCLoginProvider") {
                let authProviders = [MockROPCProviding(type: .keycloak), MockROPCProviding(type: .keycloak)]
                let providers = factory.buildProviders(authenticationProviders: authProviders,
                                                       tokenStore: MockTokenStore())
                expect(providers.count) == 2
//                expect(providers).to(allPass(beAnInstanceOf(ROPCLoginProvider.self)))
            }
        }
    }

    private struct MockROPCProviding: ROPCAuthenticationProviding {
        let scopes: String = "scopes"
        let clientId: String = "app"
        let headerParamProvider: HeaderParamProviding = HeaderParamProviderMock(sdkVersion: "1.0.0")
        let stageName: String = "prod"
        let urlProvider: UrlProviding = ROPCUrlProviderMock()
        let type: AuthenticationType
        
        init(type: AuthenticationType) {
            self.type = type
        }
    }
    
    private struct MockSomethingElseProviding: AuthenticationProviding {
        var type: AuthenticationType = .keycloak
    }
}
