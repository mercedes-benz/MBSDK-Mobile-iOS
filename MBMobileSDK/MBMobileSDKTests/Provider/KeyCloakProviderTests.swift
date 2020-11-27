//
// Copyright (c) 2020 MBition GmbH. All rights reserved.
//

@testable import MBMobileSDK
import XCTest

class KeyCloakProviderTests: XCTestCase {

    struct KeyCloakProviderTestsConstants {
        static let fixtureClientId = "testClientId"
        static let fixtureSdkVersion = "_._._"
    }

    override class func setUp() {
        super.setUp()
    }

    override class func tearDown() {
        super.tearDown()
    }

    func testKeyCloakProvider_init() {
		
        let provider = DefaultKeycloakProvider(clientIdentifier: KeyCloakProviderTestsConstants.fixtureClientId, sdkVersion: KeyCloakProviderTestsConstants.fixtureSdkVersion)

        XCTAssertEqual(provider.clientId, KeyCloakProviderTestsConstants.fixtureClientId)
        XCTAssertNotNil(provider.urlProvider)
    }

    func testKeycloakProvider_urlProviding_prod() {
		
        MBMobileSDKEndpoint.modifiedRegion = .ece
        MBMobileSDKEndpoint.modifiedStage = .prod

        let provider = DefaultKeycloakProvider(clientIdentifier: KeyCloakProviderTestsConstants.fixtureClientId, sdkVersion: KeyCloakProviderTestsConstants.fixtureSdkVersion)

        let urlProvider = provider.urlProvider
        XCTAssertNotNil(urlProvider)

        let expectedUrl = "https://keycloak.risingstars.daimler.com/auth/realms/Daimler"
        let providedUrl = urlProvider.baseUrl

        XCTAssertFalse(providedUrl.isEmpty)
        XCTAssertEqual(providedUrl, expectedUrl)
    }

    func testKeycloakProvider_urlProviding_mock() {

        MBMobileSDKEndpoint.modifiedRegion = .ece
        MBMobileSDKEndpoint.modifiedStage = .mock

        let provider = DefaultKeycloakProvider(clientIdentifier: KeyCloakProviderTestsConstants.fixtureClientId, sdkVersion: KeyCloakProviderTestsConstants.fixtureSdkVersion)

        let urlProvider = provider.urlProvider
        XCTAssertNotNil(urlProvider)

        let expectedUrl = "https://keycloak.risingstars-mock.daimler.com/auth/realms/Daimler"
        let providedUrl = urlProvider.baseUrl

        XCTAssertFalse(providedUrl.isEmpty)
        XCTAssertEqual(providedUrl, expectedUrl)
    }
}
