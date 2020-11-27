//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

enum BffServicesRouter: EndpointRouter {
	case get(accessToken: String, vin: String, locale: String, fillMissingData: Bool, grouped: String?, services: [Int]?)
	case update(accessToken: String, vin: String, locale: String, requestModel: [[String: Any]]?)

	
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
		case .get(let accessToken, _, let locale, _, _, _),
			 .update(let accessToken, _, let locale, _):
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
		let ciamId = "self"
		switch self {
		case .get(_, let vin, _, _, _, _),
			 .update(_, let vin, _, _):
			return "/vehicle/\(vin)/user/\(ciamId)/services"
		}
	}
	var parameters: [String: Any]? {
		switch self {
		case .get(_, _, let locale, let fillMissingData, let grouped, let services):
			var params: [String: Any] = [
				"locale": locale,
				"fillMissingData": fillMissingData
			]
			
			if let grouped = grouped {
				params["group_by"] = grouped
			}
			
			if let services = services,
				services.isEmpty == false {
				params["id"] = services.map { "\($0)" }.joined(separator: ",")
			}
			return params
			
		case .update(_, _, let locale, let requestModel):
			var params: [String: Any] = [
				"locale": locale
			]
			
			if requestModel == nil {
				params["activateAll"] = true
			}
			
			return params
		}
	}

	var parameterEncoding: ParameterEncodingType {
		switch self {
		case .get:
			return .url(type: .standard)

		case .update:
            return .url(type: .query)
		}
	}

    var bodyParameters: [String: Any]? {
		switch self {
		case .get:
			return nil
			
		case .update(_, _, _, let requestModel):
			guard let requestModel = requestModel else {
				return [:]
			}
			
			return [
				"services": requestModel
			]
		}
    }

    var bodyEncoding: ParameterEncodingType {
		switch self {
		case .get:
			return self.parameterEncoding
			
		case .update:
			return .json
		}
    }
    
	var cachePolicy: URLRequest.CachePolicy? {
		return nil
	}
	
	var timeout: TimeInterval {
		return CarKit.bffProvider?.urlProvider.requestTimeout ?? CarKit.defaultRequestTimeout
	}
}
