//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

enum CustomUrlRouter: EndpointRouter {
	case url(string: String)
	
	
	// MARK: - EndpointRouter
	
	var baseURL: String {
		switch self {
		case .url(let string):
			guard let components = URLComponents(string: string),
				let scheme = components.scheme,
				let host = components.host else {
					return ""
			}
			return scheme + "://" + host
		}
	}
	
	var method: HTTPMethodType {
		return .get
	}
	
	var path: String {
		switch self {
		case .url(let string):
			guard let components = URLComponents(string: string) else {
				return ""
			}
			
			return components.path
		}
	}
	
	var parameters: [String: Any]? {
		return nil
	}
	
	var parameterEncoding: ParameterEncodingType {
		return .url(type: .standard)
	}
	
	var cachePolicy: URLRequest.CachePolicy? {
		return nil
	}
	
	var httpHeaders: [String: String]? {
		return nil
	}
}
