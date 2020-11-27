//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit
import MBMobileSDK

// MARK: - BffProvider

final public class BffProviderMock {

	static var providerSessionId: String = "0D7F9C40-C650-4807-9EEC-ACFB9783FCCD"
	private var sdkVersion: String


	// MARK: - Init

	public init(sdkVersion: String) {

		guard sdkVersion.isEmpty == false else {
			fatalError("no sdk version available")
		}

		self.sdkVersion = sdkVersion
	}
}

extension BffProviderMock: BffProviding {

	public var headerParamProvider: HeaderParamProviding {
		return HeaderParamProviderMock(sdkVersion: self.sdkVersion)
	}

	/// session id for bff
	public var sessionId: String {
		get {
			return BffProviderMock.providerSessionId
		}
		set {
			BffProviderMock.providerSessionId = newValue
		}
	}

	public var urlProvider: UrlProviding {
		return BffUrlProviderMock()
	}
}

// MARK: - BffUrlProvider

final class BffUrlProviderMock {

	init() {}
}

extension BffUrlProviderMock: UrlProviding {

	var baseUrl: String {
		return "https://mock"
	}
}


// MARK: - HeaderParam

struct HeaderParamKey {
	static let authorization 		= "Authorization"
	static let sdkVersion			= "RIS-SDK-Version"
	static let operatingName	    = "RIS-OS-Name"
	static let operatingVersion		= "RIS-OS-Version"
	static let locale				= "X-Locale"
	static let sessionId 			= "X-SessionId"
	static let trackingId 			= "X-TrackingId"
	static let countryCode 			= "X-MarketCountryCode"
	static let applicationName      = "X-ApplicationName"
	static let applicationVersion   = "X-ApplicationVersion"
    static let ldssoAppId           = "ldsso-AppId"
    static let ldssoAppVersion      = "ldsso-AppVersion"
}


// MARK: - HeaderParamProvider

final public class HeaderParamProviderMock {

	private var sdkVersion: String


	// MARK: - Init

	init(sdkVersion: String) {
		self.sdkVersion = sdkVersion
	}
}

extension HeaderParamProviderMock: HeaderParamProviding {
    
    public var authorizationModeParamKey: String {
        return HeaderParamKey.authorization
    }
    
	public var authorizationHeaderParamKey: String {
		return HeaderParamKey.authorization
	}

	public var countryCodeHeaderParamKey: String {
		return HeaderParamKey.countryCode
	}

	public var defaultHeaderParams: [String: String] {
		
		let defaultLocale: String = {
            return "de-DE"
		}()
		
		return [
			HeaderParamKey.sessionId: BffProviderMock.providerSessionId,
			HeaderParamKey.trackingId: "F80921E6-1A6F-473A-A336-23C865CC62FC",
			HeaderParamKey.applicationName: "MBIngress_Mock",
			HeaderParamKey.sdkVersion: self.sdkVersion,
			HeaderParamKey.locale: defaultLocale,
			HeaderParamKey.operatingName: "ios_mock",
		]
	}

	public var localeHeaderParamKey: String {
		return HeaderParamKey.locale
	}
    
    public var ldssoAppHeaderParams: [String: String] {
        return [
            HeaderParamKey.ldssoAppId: "1716",
            HeaderParamKey.ldssoAppVersion: "1716_4315"
        ]
    }
}


// MARK: - KeycloakProviding

final public class ROPCAuthenticationProviderMock {

    var mockAuthType: AuthenticationType = .keycloak
    
	private var sdkVersion: String


	// MARK: - Init

	public init(sdkVersion: String) {

		guard sdkVersion.isEmpty == false else {
			fatalError("no sdk version available")
		}

		self.sdkVersion = sdkVersion
	}
}


extension ROPCAuthenticationProviderMock: ROPCAuthenticationProviding {
    
    public var type: AuthenticationType {
        return mockAuthType
    }
    
	public var clientId: String {
		return "mock_clientId"
	}

	public var headerParamProvider: HeaderParamProviding {
		return HeaderParamProviderMock(sdkVersion: self.sdkVersion)
	}
	
	public var stageName: String {
		return "int"
	}
    
    public var scopes: String {
        return "some scopes"
    }

	public var urlProvider: UrlProviding {
		return ROPCUrlProviderMock()
	}
}

class ROPCUrlProviderMock: UrlProviding {
	var baseUrl: String {
		return "https://keycloak-mock.risingstars.daimler.com"
	}
}
