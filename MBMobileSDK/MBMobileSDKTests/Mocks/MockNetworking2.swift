//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import MBNetworkKit

@testable import MBMobileSDK
@testable import MBNetworkKit

class MockNetworkService: Networking {
	
	// MARK: Properties
	
	var returnedData: Data?
	var returnedDecodable: Decodable?
	var returnedError: MBError?
	
	
	// MARK: - Helper
	
	func reset() {
		
		self.returnedData = nil
		self.returnedDecodable = nil
		self.returnedError = nil
	}
	
	
	// MARK: - Networking
	
    func request<T, S>(router: EndpointRouter, errorType: S.Type, completion: @escaping (Result<T, MBError>) -> Void) -> URLSessionTask? where T : Decodable, S : MBErrorConformable {
		
		if let returnedDecodable = self.returnedDecodable {
            completion(.success(returnedDecodable as! T))
		} else if let error = self.returnedError {
            completion(.failure(error))
        }
        return nil
    }
    
	func request<T: Decodable>(router: EndpointRouter, keyPath: String?, completion: @escaping (Result<T, MBError>) -> Void) -> URLSessionTask? {
		
		if let returnedDecodable = self.returnedDecodable {
            completion(.success(returnedDecodable as! T))
		} else if let error = self.returnedError {
            completion(.failure(error))
        }
        return nil
    }
    
	func request<T: Decodable>(router: EndpointRouter, completion: @escaping (Result<(value: T, headers: [AnyHashable: Any]), MBError>) -> Void) -> URLSessionTask? {
		
		if let returnedDecodable = self.returnedDecodable {
			completion(.success((value: returnedDecodable as! T, headers: [:])))
		} else if let error = self.returnedError {
			completion(.failure(error))
		}
		return nil
	}
	
    func request(router: EndpointRouter, completion: @escaping (Result<Void, MBError>) -> Void) -> URLSessionTask? {
		
		if let error = self.returnedError {
            completion(.failure(error))
        }
        return nil
    }
    
    func request(router: EndpointRouter, completion: @escaping (Result<Data, MBError>) -> Void) -> URLSessionTask? {
		
		if let returnedData = self.returnedData {
            completion(.success(returnedData))
		} else if let error = self.returnedError {
            completion(.failure(error))
        }
        
        return nil
    }
}
