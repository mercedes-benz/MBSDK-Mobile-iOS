//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

enum BffAssignmentRouter: EndpointRouter {
	case addQR(accessToken: String, link: String)
	case addVIN(accessToken: String, vin: String)
	case confirm(accessToken: String, vac: String, vin: String)
	case delete(accessToken: String, vin: String)

	
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
		case .addQR(let accessToken, _),
			 .addVIN(let accessToken, _),
			 .confirm(let accessToken, _, _),
			 .delete(let accessToken, _):
            headers[headerParamProvider.authorizationHeaderParamKey] = accessToken.addBearerAuthHeaderPrefix()
		}
		
		return headers
	}
	var method: HTTPMethodType {
		switch self {
		case .addQR:	return .post
		case .addVIN:	return .put
		case .confirm:	return .put
		case .delete:	return .delete
		}
	}
	var path: String {
		
		let ciamId = "self"
		switch self {
		case .addQR:
			return "/qr-assignment"
			
		case .addVIN(_, let vin):
			return "/vehicle/\(vin)/user/\(ciamId)/assignment"

		case .confirm(_, _, let vin):
            return "/vehicles/\(vin)/vehicle-assignment-code-confirmation"

		case .delete(_, let vin):
			return "/vehicle/\(vin)/user/assignment"
		}
	}
	var parameters: [String: Any]? {
		return nil
	}

	var parameterEncoding: ParameterEncodingType {
		switch self {
		case .addQR:	return .url(type: .query)
		case .confirm,
             .addVIN,
			 .delete:	return .json
		}
	}

    var bodyParameters: [String: Any]? {
		switch self {
		case .addQR(_, let link):
			return [
				"qrLink": link
			]
			
		case .addVIN,
			 .delete:
			return nil
			
		case .confirm(_, let vac, _):
			return [
				"code": vac
            ]
		}
    }

    var bodyEncoding: ParameterEncodingType {
		switch self {
		case .addQR:	return .json
		case .addVIN,
			 .confirm,
			 .delete:	return self.parameterEncoding
		}
    }
    
	var cachePolicy: URLRequest.CachePolicy? {
		return nil
	}
	
	var timeout: TimeInterval {
		return CarKit.bffProvider?.urlProvider.requestTimeout ?? CarKit.defaultRequestTimeout
	}
}
