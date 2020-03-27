//
// Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCarKit
import MBCommonKit
import MBNetworkKit

public protocol MBMobileSDKContextConformable {
	
	var bffProvider: BffProviding { get set}
	var cdnUrlProvider: UrlProviding { get }
	var keycloakProvider: KeycloakProviding { get }
	var pinProvider: PinProviding { get }
	var socketProvider: SocketProviding { get }
	var tokenProvider: TokenProviding { get }
	
	func updateSocketUrl()
}


struct MobileSDKContext: MBMobileSDKContextConformable {
	var bffProvider: BffProviding
	let cdnUrlProvider: UrlProviding
	let keycloakProvider: KeycloakProviding
	let pinProvider: PinProviding
	let socketProvider: SocketProviding
	let tokenProvider: TokenProviding


	// MARK: - Init
	
	init(configuration: MBMobileSDKConfiguration) {

		HeaderParamProvider.applicationIdentifier = configuration.applicationIdentifier
		
		let sdkVersion = ModuleBundle.mobileSdk.shortVersion
		self.bffProvider = BffProvider(sdkVersion: sdkVersion)
		self.cdnUrlProvider = CdnUrlProvider()
		self.keycloakProvider = KeycloakProvider(clientIdentifier: configuration.clientId)
		self.pinProvider = DefaultPinProvider()
		self.socketProvider = SocketProvider(sdkVersion: sdkVersion)
		self.tokenProvider = TokenProvider()
    }
	
	
	// MARK: - MBMobileSDKContextConformable
	
	func updateSocketUrl() {
		Socket.socketBaseUrl = self.socketProvider.urlProvider.baseUrl
	}
}
