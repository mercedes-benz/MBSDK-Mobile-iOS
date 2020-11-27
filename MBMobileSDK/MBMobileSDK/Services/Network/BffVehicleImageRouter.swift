//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

enum BffVehicleImageRouter: EndpointRouter {
	case image(accessToken: String, vin: String, requestModel: [String: Any]?)
	case images(accessToken: String, requestModel: [String: Any]?)
    case topViewImage(accessToken: String, vin: String)

	
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
		case .image(let accessToken, _, _),
			 .images(let accessToken, _),
             .topViewImage(let accessToken, _):
            headers[headerParamProvider.authorizationHeaderParamKey] = accessToken.addBearerAuthHeaderPrefix()
		}
		
		return headers
	}
	var method: HTTPMethodType {
		return .get
	}
	var path: String {
		let ciamId = "self"
		switch self {
		case .image(_, let vin, _):
			return "/vehicle/\(vin)/images"
			
		case .images:
			return "/user/\(ciamId)/vehicleimages"
            
		case .topViewImage(_, let vin):
            return "/vehicle/\(vin)/topviewimage"
		}
	}
	var parameters: [String: Any]? {
		switch self {
		case .image(_, _, let requestModel),
			 .images(_, let requestModel):
			return requestModel
			
		case .topViewImage:
            return nil
		}
	}

	var parameterEncoding: ParameterEncodingType {
		return .url(type: .standard)
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
