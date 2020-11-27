//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

enum BffCapabilitiesRouter: EndpointRouter {
	case commands(accessToken: String, vin: String)
	case sendToCar(accessToken: String, vin: String)
    case sendToCarV2(accessToken: String, vin: String)

	
	// MARK: - Properties
	
	var baseURL: String {
		guard let urlProvider = CarKit.bffProvider?.urlProvider else {
			fatalError("This is a placeholder implementation. Please implement your own bffProvider or use the implementation from MBMobileSDK")
		}
		return urlProvider.baseUrl
	}
	var httpHeaders: [String: String]? {
		
		guard let headerParamProvider = CarKit.bffProvider?.headerParamProvider else {
			fatalError("This is a placeholder implementation. Please implement your own headerParamProvider or use the implementation from MBMobileSDK")
		}
        var headers = headerParamProvider.defaultHeaderParams
        
		switch self {
		case .commands(let accessToken, _),
			 .sendToCar(let accessToken, _),
             .sendToCarV2(let accessToken, _):
            headers[headerParamProvider.authorizationHeaderParamKey] = accessToken.addBearerAuthHeaderPrefix()
		}
		
		return headers
	}
	var method: HTTPMethodType {
		return .get
	}
	var path: String {
		switch self {
		case .commands(_, let vin):
			return "/vehicle/\(vin)/capabilities/commands"

		case .sendToCar(_, let vin):
			return "/vehicle/\(vin)/HUNotifCapability"
            
		case .sendToCarV2(_, let vin):
            return "/vehicle/\(vin)/capabilities/sendtocar"
		}
	}
	var parameters: [String: Any]? {
		return nil
	}

	var parameterEncoding: ParameterEncodingType {
		return .json
	}

    var bodyParameters: [String: Any]? {
		return nil
    }

    var bodyEncoding: ParameterEncodingType {
		return self.parameterEncoding
    }
    
	var cachePolicy: URLRequest.CachePolicy? {
		return nil
	}
	
	var timeout: TimeInterval {
		return CarKit.bffProvider?.urlProvider.requestTimeout ?? CarKit.defaultRequestTimeout
	}
}
