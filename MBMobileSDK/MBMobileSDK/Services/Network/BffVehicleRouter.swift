//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

enum BffVehicleRouter: EndpointRouter {
	case automaticValetParking(accessToken: String, vin: String, requestModel: [String: Any]?)
    case automaticValetParkingReservationStatus(accessToken: String, vin: String, reservationIds: [String])
	case consumption(accessToken: String, vin: String)
	case dealers(accessToken: String, requestModel: [String: Any]?)
	case dealersPreferred(accessToken: String, vin: String, requestModel: [[String: Any]]?)
	case licensePlate(accessToken: String, vin: String, locale: String, license: String)
	case masterdata(accessToken: String, countryCode: String, locale: String)
    case softwareUpdate(accessToken: String, vin: String, locale: String)
    case resetDamageDetection(accessToken: String, vin: String, pin: String)
	case rifability(accessToken: String, vin: String)
	case route(accessToken: String, vin: String, requestModel: [String: Any]?)
	
	
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
		case .automaticValetParking(let accessToken, _, _),
             .automaticValetParkingReservationStatus(let accessToken, _, _),
			 .consumption(let accessToken, _),
			 .dealers(let accessToken, _),
			 .dealersPreferred(let accessToken, _, _),
			 .masterdata(let accessToken, _, _),
             .softwareUpdate(let accessToken, _, _),
			 .resetDamageDetection(let accessToken, _, _),
			 .rifability(let accessToken, _),
			 .route(let accessToken, _, _):
            headers[headerParamProvider.authorizationHeaderParamKey] = accessToken.addBearerAuthHeaderPrefix()

		case .licensePlate(let accessToken, _, let locale, _):
            headers[headerParamProvider.authorizationHeaderParamKey] = accessToken.addBearerAuthHeaderPrefix()
			headers[headerParamProvider.countryCodeHeaderParamKey] = locale
		}
		
		return headers
	}
	var method: HTTPMethodType {
		switch self {
		case .automaticValetParking:	                return .post
		case .automaticValetParkingReservationStatus:   return .get
		case .consumption:				                return .get
		case .dealers:					                return .post
		case .dealersPreferred:			                return .put
		case .licensePlate:				                return .put
		case .masterdata:				                return .get
        case .softwareUpdate:                           return .get
		case .resetDamageDetection:		                return .delete
		case .rifability:				                return .get
		case .route:		 			                return .post
		}
	}
	var path: String {
		let ciamId = "self"
		switch self {
		case .automaticValetParking(_, let vin, _):
			return "vehicle/\(vin)/acceptavpdrive"
			
		case .automaticValetParkingReservationStatus(_, let vin, _):
            return "vehicle/\(vin)/avp/reservationstatus"
			
		case .consumption(_, let vin):
			return "vehicle/\(vin)/consumption"
			
		case .dealers:
            return "/outlets"

		case .dealersPreferred(_, let vin, _):
			return "/vehicle/\(vin)/dealers"
			    
		case .licensePlate(_, let vin, _, _):
			return "/vehicles/\(vin)/licenseplate"

		case .masterdata:
			return "/vehicle/\(ciamId)/masterdata"
            
        case .softwareUpdate(_, let vin, _):
            return "/vehicle/\(vin)/softwareupdate"
			
		case .resetDamageDetection(_, let vin, _):
			return "/vehicle/\(vin)/damagedetection"
			
		case .rifability(_, let vin):
			return "/rifability/\(vin)"
			
		case .route(_, let vin, _):
			return "/vehicle/\(vin)/route"
		}
	}
	var parameters: [String: Any]? {
		switch self {
		case .automaticValetParking,
			 .consumption,
			 .dealers,
			 .dealersPreferred,
			 .licensePlate:
			return nil
            
		case .automaticValetParkingReservationStatus(_, _, let reservationIds):
            return [
                "reservationIds": reservationIds.joined(separator: ",")
            ]
            
		case .masterdata(_, let countryCode, let locale):
			return [
				"countryCode": countryCode,
				"locale": locale
			]
            
        case .softwareUpdate(_, _, let locale):
            return [
                "locale": locale
            ]
            
		case .resetDamageDetection(_, _, let pin):
            return [
                "pin": pin
            ]
			
		case .rifability,
			 .route:
			return nil
		}
	}

	var parameterEncoding: ParameterEncodingType {
		switch self {
		case .automaticValetParking,
			 .consumption,
			 .dealers,
			 .dealersPreferred:
            return .json
            
		case .automaticValetParkingReservationStatus:
            return .url(type: .query)
            
		case .licensePlate:
			return .url(type: .query)

		case .masterdata:
			return .url(type: .standard)
            
        case .softwareUpdate:
            return .url(type: .query)
			
		case .resetDamageDetection,
			 .rifability:
			return .json
			
		case .route:
			return .url(type: .query)
		}
	}

    var bodyParameters: [String: Any]? {
		switch self {
		case .automaticValetParking(_, _, let requestModel):
			return requestModel
        
		case .automaticValetParkingReservationStatus:
            return nil
            
		case .consumption:
			return nil
			
		case .dealers(_, let requestModel):
			return requestModel

		case .dealersPreferred(_, _, let requestModel):
			guard let requestModel = requestModel else {
				return nil
			}
			
			return [
				"items": requestModel
			]
			
		case .licensePlate(_, _, _, let license):
			return [
				"licenseplate": license
			]
			
		case .masterdata,
             .softwareUpdate,
			 .resetDamageDetection,
			 .rifability:
			return nil
			
		case .route(_, _, let requestModel):
			return requestModel
		}
    }

    var bodyEncoding: ParameterEncodingType {
		switch self {
		case .automaticValetParking:
			return .json
            
		case .automaticValetParkingReservationStatus:
            return self.parameterEncoding
            
		case .consumption:
			return self.parameterEncoding
			
		case .dealers,
			 .dealersPreferred:
			return .json
			
		case .licensePlate:
			return .json
			
		case .masterdata,
             .softwareUpdate,
			 .resetDamageDetection,
			 .rifability:
			return self.parameterEncoding
			
		case .route:
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
