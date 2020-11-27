//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

// swiftlint:disable switch_case_alignment

enum BffImageRouter: EndpointRouter {
	case get(accessToken: String)
    case getCached(accessToken: String, eTag: String?)
	case upload(accessToken: String)
    
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
        
        switch self {
        case .get(let accessToken),
             .upload(let accessToken):
            headers[headerParamProvider.authorizationHeaderParamKey] = accessToken.addBearerAuthHeaderPrefix()
            
        case .getCached(let accessToken, let eTag):
            headers[headerParamProvider.authorizationHeaderParamKey] = accessToken.addBearerAuthHeaderPrefix()
            if let eTag = eTag {
                headers["If-None-Match"] = eTag
            }
		}
		
		return headers
	}
	var method: HTTPMethodType {
		switch self {
        case .get, .getCached:		return .get
		case .upload:	            return .put
		}
	}
	var path: String {
        switch self {
        case .getCached:
            return "user/profilepicture"
        case .upload, .get:
            let ciamId = "self"
            return "user/\(ciamId)/profilepicture"
        }
	}
	var parameters: [String: Any]? {
		return nil
	}
	var parameterEncoding: ParameterEncodingType {
		return .json
	}
	var cachePolicy: URLRequest.CachePolicy? {
        switch self {
        case .getCached:
            return .reloadIgnoringLocalCacheData
        default:
            return .useProtocolCachePolicy
        }
	}
	var bodyParameters: [String: Any]? {
		return nil
	}
	var bodyEncoding: ParameterEncodingType {
		return self.parameterEncoding
	}
	var timeout: TimeInterval {
		return IngressKit.bffProvider?.urlProvider.requestTimeout ?? IngressKit.defaultRequestTimeout
	}
}
