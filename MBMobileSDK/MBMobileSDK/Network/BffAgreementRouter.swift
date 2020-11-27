//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

enum BffAgreementRouter: EndpointRouter {
	case get(accessToken: String?, countryCode: String, locale: String, checkForNewVersions: Bool)
    case update(accessToken: String, locale: String, requestModel: [String: Any]?)
    
	// MARK: Properties
	var baseURL: String {
		guard let urlProvider = IngressKit.bffProvider?.urlProvider else {
			fatalError("This is a placeholder implementation. Please implement your own bffProvider or use the implementation from MBMobileSDK")
		}
		return urlProvider.baseUrl
	}
	var httpHeaders: [String: String]? {
		
		guard let headerParamProvider = IngressKit.bffProvider?.headerParamProvider else {
			fatalError("This is a placeholder implementation. Please implement your own headerParamProvider or use the implementation from MBMobileSDK")
		}

		var headers = headerParamProvider.defaultHeaderParams
		for param in headerParamProvider.ldssoAppHeaderParams {
			headers[param.key] = param.value
		}
		
        switch self {
        case .get(let accessToken, _, let locale, _):
            headers[headerParamProvider.localeHeaderParamKey] = locale
			
			if let accessToken = accessToken {
                headers[headerParamProvider.authorizationHeaderParamKey] = accessToken.addBearerAuthHeaderPrefix()
			}
		
        case .update(let accessToken, let locale, _):
            headers[headerParamProvider.authorizationHeaderParamKey] = accessToken.addBearerAuthHeaderPrefix()
            headers[headerParamProvider.localeHeaderParamKey] = locale
        }
		
		return headers
	}
	var method: HTTPMethodType {
		switch self {
		case .get:		return .get
		case .update:	return .post
		}
	}
	var path: String {
		switch self {
		case .get:		return "agreements"
		case .update:	return "/user/agreements"
		}
	}
	var parameters: [String: Any]? {
		switch self {
		case .get(_, let countryCode, let locale, let checkForNewVersions):
			var query = [
				"addressCountry": countryCode,
				"locale": locale
			]
			if checkForNewVersions {
				query["usecase"] = "CHECK_FOR_NEW_VERSIONS"
			}
			return query
		
		case .update:
			return nil
		}
	}
	var parameterEncoding: ParameterEncodingType {
		switch self {
		case .get:		return .url(type: .standard)
		case .update:	return .url(type: .query)
        }
	}
	var cachePolicy: URLRequest.CachePolicy? {
		return nil
	}
	var bodyParameters: [String: Any]? {
		switch self {
		case .get:								return nil
		case .update(_, _, let requestModel):	return requestModel
		}
	}
	var bodyEncoding: ParameterEncodingType {
		switch self {
		case .get:		return self.parameterEncoding
		case .update:	return .json
		}
	}
	var timeout: TimeInterval {
		return IngressKit.bffProvider?.urlProvider.requestTimeout ?? IngressKit.defaultRequestTimeout
	}
}
