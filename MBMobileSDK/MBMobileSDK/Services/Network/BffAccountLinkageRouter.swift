//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

enum BffAccountLinkageRouter: EndpointRouter {
	case consent(accessToken: String, finOrVin: String, accountType: String, vendorId: String)
	case delete(accessToken: String, finOrVin: String, accountType: String, vendorId: String)
	case get(accessToken: String, finOrVin: String, serviceIds: [Int]?, redirectUrl: String?)
	case update(accessToken: String, finOrVin: String)

	
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
		case .consent(let accessToken, _, _, _),
			 .delete(let accessToken, _, _, _),
			 .get(let accessToken, _, _, _),
			 .update(let accessToken, _):
            headers[headerParamProvider.authorizationHeaderParamKey] = accessToken.addBearerAuthHeaderPrefix()
		}
		
		return headers
	}
	var method: HTTPMethodType {
		switch self {
		case .consent:	return .put
		case .delete:	return .delete
		case .get:		return .get
		case .update:	return .put
		}
	}
	var path: String {
		switch self {
		case .consent(_, let finOrVin, _, _):
            return "/vehicle/\(finOrVin)/accounts/consent"
			
		case .delete(_, let finOrVin, _, _),
			.get(_, let finOrVin, _, _),
			.update(_, let finOrVin):
            return "/vehicle/\(finOrVin)/accounts"
		}
	}
	var parameters: [String: Any]? {
		switch self {
		case .consent(_, _, let accountType, let vendorId):
			return [
				"accountType": accountType,
				"VendorId": vendorId
			]
			
		case .delete(_, _, let accountType, let vendorId):
			return [
				"accountType": accountType,
				"vendorId": vendorId
			]
				
		case .get(_, _, let serviceIds, let redirectUrl):
			let serviceDict: [String: String] = {
				guard let serviceIds = serviceIds else {
					return [:]
				}
				return [
					"serviceIds": serviceIds.map { "\($0)" }.joined(separator: ",")
				]
			}()
			let redirectDict: [String: String] = {
				guard let redirectUrl = redirectUrl else {
					return [:]
				}
				return [
					"connectRedirectURL": redirectUrl
				]
			}()
			return serviceDict.merging(redirectDict) { (current, _) in current }
			
		case .update:
            return nil
		}
	}

	var parameterEncoding: ParameterEncodingType {
		return .url(type: .query)
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
