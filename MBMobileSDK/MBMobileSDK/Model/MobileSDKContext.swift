//
// Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

import MBCommonKit
import MBNetworkKit

public protocol MBMobileSDKContextConformable {
	
	var authenticationProviders: [AuthenticationProviding] { get }
	var bffProvider: BffProviding { get set}
	var cdnUrlProvider: UrlProviding { get }
	var pinProvider: PinProviding? { get }
	var socketProvider: SocketProviding { get }
	var tokenProvider: TokenProviding { get }
	
	func updateSocketUrl()
}


struct MobileSDKContext: MBMobileSDKContextConformable {
	
    var authenticationProviders: [AuthenticationProviding]
	var bffProvider: BffProviding
    
	let cdnUrlProvider: UrlProviding
	var pinProvider: PinProviding?
	let socketProvider: SocketProviding
	let tokenProvider: TokenProviding

    private let authenticationProviderFactory: AuthenticationProviderBuilding = AuthenticationProviderFactory()
	
	
	// MARK: - Init
	
	init(configuration: MBMobileSDKConfiguration) {

		DefaultHeaderParamProvider.applicationIdentifier = configuration.applicationIdentifier
		
		let sdkVersion = ModuleBundle.mobileSdk.shortVersion
        self.authenticationProviders = self.authenticationProviderFactory.buildProviders(
            configurations: configuration.authenticationConfigs,
            sdkVersion: sdkVersion)
		self.bffProvider = DefaultBffProvider(sdkVersion: sdkVersion)
		self.cdnUrlProvider = DefaultCdnUrlProvider()

		self.socketProvider = DefaultSocketProvider(sdkVersion: sdkVersion)
		self.tokenProvider = DefaultTokenProvider()
    }
	
	
	// MARK: - MBMobileSDKContextConformable
	
	func updateSocketUrl() {
		Socket.socketBaseUrl = self.socketProvider.urlProvider.baseUrl
	}
}
