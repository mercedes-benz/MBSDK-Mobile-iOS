//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

enum BffUserManagementRouter: EndpointRouter {
	case get(accessToken: String, vin: String, locale: String)
    case delete(accessToken: String, vin: String, authorizationID: String)
	case inviteQR(accessToken: String, vin: String, profileId: VehicleProfileID?)
    case profileSyncState(accessToken: String, vin: String)
    case setProfileSync(accessToken: String, vin: String, enabled: Bool)
    case syncState(accessToken: String, vin: String)
    case upgradeTemporaryUser(accessToken: String, authorizationID: String, finOrVin: String)
    case normalizedProfileControl(accessToken: String)
	case setNormalizedProfileControl(accessToken: String, enabled: Bool)
    
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
		case .delete(let accessToken, _, _),
             .inviteQR(let accessToken, _, _),
             .profileSyncState(let accessToken, _),
             .setProfileSync(let accessToken, _, _),
             .syncState(let accessToken, _),
             .upgradeTemporaryUser(let accessToken, _, _),
             .normalizedProfileControl(let accessToken),
             .setNormalizedProfileControl(let accessToken, _):
            headers[headerParamProvider.authorizationHeaderParamKey] = accessToken.addBearerAuthHeaderPrefix()

		case .get(let accessToken, _, let locale):
            headers[headerParamProvider.authorizationHeaderParamKey] = accessToken.addBearerAuthHeaderPrefix()
			headers[headerParamProvider.countryCodeHeaderParamKey] = locale
		}
		
		return headers
	}
    
	var method: HTTPMethodType {
		switch self {
		case .get:                          return .get
		case .delete:                       return .delete
		case .inviteQR:                     return .post
		case .profileSyncState:             return .get
		case .setProfileSync:               return .put
		case .syncState:                    return .get
		case .upgradeTemporaryUser:         return .put
		case .normalizedProfileControl:     return .get
		case .setNormalizedProfileControl:  return .put
		}
	}
    
	var path: String {
		switch self {
		case .get(_, let vin, _):
			return "/vehicles/\(vin)/users"
			
		case .delete(_, let vin, _):
			return "/vehicle/\(vin)/user/authorization"
            
		case .inviteQR:
			return "/qr-invitation"
            
		case .profileSyncState(_, let vin):
            return "/vehicle/\(vin)/personalization/automaticSyncScreen"
            
		case .setProfileSync(_, let vin, _):
            return "/vehicles/\(vin)/profiles/sync"
            
		case .syncState(_, let vin):
            return "/vehicle/\(vin)/personalization/syncState/pin"
            
		case .upgradeTemporaryUser(_, let authorizationID, let finOrVin):
            return "/vehicles/\(finOrVin)/users/\(authorizationID)/upgrade"
            
		case .normalizedProfileControl,
             .setNormalizedProfileControl:
            return "/user/personalization/normalizedprofilecontrol"
		}
	}
    
	var parameters: [String: Any]? {
		switch self {
		case .get,
             .profileSyncState,
             .syncState,
             .upgradeTemporaryUser,
             .normalizedProfileControl,
             .setNormalizedProfileControl:
			return nil
			
		case .delete(_, _, let authorizationID):
            return [
                "authorizationId": authorizationID
            ]
            
		case .inviteQR( _, let vin, let profileId):
			return [
				"finOrVin": vin,
				"correlationId": profileId as Any
			]
            
		case .setProfileSync(_, let vin, _):
            return [
                "finOrVin": vin
            ]
        }
	}

	var parameterEncoding: ParameterEncodingType {
		switch self {
		case .get:
			return .url(type: .query)
			
		case .delete:
            return .url(type: .query)
            
		case .inviteQR:
			return .json
            
		case .profileSyncState:
            return .url(type: .query)
            
		case .setProfileSync:
            return .url(type: .query)
            
		case .syncState:
            return .json

		case .upgradeTemporaryUser:
            return .url(type: .query)
            
		case .normalizedProfileControl:
            return .json
            
		case .setNormalizedProfileControl:
            return .url(type: .query)
		}
	}

    var bodyParameters: [String: Any]? {
        switch self {
        case .get,
             .delete,
             .inviteQR,
             .profileSyncState,
             .syncState,
             .upgradeTemporaryUser,
             .normalizedProfileControl:
            return nil
            
        case .setProfileSync(_, _, let enabled):
            return [
                "desiredState": enabled
            ]
            
        case .setNormalizedProfileControl(_, let enabled):
            return [
                "enabled": enabled
            ]
        }
    }

    var bodyEncoding: ParameterEncodingType {
		return .json
    }
    
	var cachePolicy: URLRequest.CachePolicy? {
		return nil
	}
	
	var timeout: TimeInterval {
		return CarKit.bffProvider?.urlProvider.requestTimeout ?? CarKit.defaultRequestTimeout
	}
}
