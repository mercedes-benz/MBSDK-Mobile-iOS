//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBCommonKit

internal final class MockBffProvider: BffProviding {

	var sessionId: String = ""

	var headerParamProvider: HeaderParamProviding {
		return MockHeaderParamProvider()
	}

	var urlProvider: UrlProviding {
		return MockUrlProvider()
	}
}

internal final class MockUrlProvider: UrlProviding {

	var baseUrl: String {
		return "https://mocked-int-bff.com"
	}
}

internal final class MockHeaderParamProvider: HeaderParamProviding {
    var authorizationModeParamKey: String {
        return ""
    }
    
	var authorizationHeaderParamKey: String {
		return "mock_auth"
	}

	var countryCodeHeaderParamKey: String {
		return "mock_GB"
	}

	var defaultHeaderParams: [String : String] {
		return [:]
	}

	var localeHeaderParamKey: String {
		return "mock_en"
	}

	var ldssoAppHeaderParams: [String : String] {
		return [:]
	}
}
