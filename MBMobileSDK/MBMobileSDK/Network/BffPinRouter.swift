//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

enum BffPinRouter: EndpointRouter {
	case change(accessToken: String, dict: [String: Any]?)
	case delete(accessToken: String, pin: String)
    case reset(accessToken: String)
	case set(accessToken: String, dict: [String: Any]?)
    
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
        case .change(let accessToken, _),
             .delete(let accessToken, _),
             .reset(let accessToken),
             .set(let accessToken, _):
            headers[headerParamProvider.authorizationHeaderParamKey] = accessToken.addBearerAuthHeaderPrefix()
        }
		
		return headers
	}
	var method: HTTPMethodType {
		switch self {
		case .change:	return .put
		case .delete:	return .delete
		case .reset:	return .post
		case .set:		return .post
		}
	}
	var path: String {
		let ciamId = "self"
		switch self {
		case .change,
			 .delete,
			 .set:		return "user/\(ciamId)/pin"
		case .reset:	return "user/pin/reset"
		}
	}
	var parameters: [String: Any]? {
		switch self {
		case .change(_, let dict),
			 .set(_, let dict):
			return dict
			
		case .delete(_, let pin):
			return [
				"currentPin": pin
			]
			
		case .reset:
			return nil
		}
	}
	var parameterEncoding: ParameterEncodingType {
		switch self {
		case .change,
			 .set:		return .json
		case .delete,
             .reset:	return .url(type: .standard)
        }
	}
	var cachePolicy: URLRequest.CachePolicy? {
		return nil
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
