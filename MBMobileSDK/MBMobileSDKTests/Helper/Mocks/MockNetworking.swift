//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Nimble
import Quick

import MBNetworkKit

@testable import MBMobileSDK

class MockNetworking: Networking {
    
    var onRequest: ((EndpointRouter) -> (model: Decodable?, error: MBError?))!
    var onDataRequest: ((EndpointRouter) -> (data: Data?, error: MBError?))!
    var onUpload: Result<Void, MBError>?
    var returnHeaders: [AnyHashable : Any] = [:]
    
    func request<T: Decodable>(router: EndpointRouter, keyPath: String?, completion: @escaping (Result<T, MBError>) -> Void) -> URLSessionTask? {
        let result = onRequest(router)
        if let error = result.error {
            completion(.failure(error))
            return nil
        } else if let model = result.model {
            completion(.success(model as! T))
            return nil
        }
        
        fail()
        return nil
    }
    
    @discardableResult
    func request<T: Decodable>(router: EndpointRouter,
                               completion: @escaping (Swift.Result<T?, MBError>) -> Void) -> URLSessionTask? {
        let result = onRequest(router)
        if let error = result.error {
            completion(.failure(error))
            return nil
        } else {
            completion(.success(result.model as? T))
            return nil
        }
    }
    
    func request<T: Decodable, S: MBErrorConformable>(router: EndpointRouter, errorType: S.Type, completion: @escaping (Result<T, MBError>) -> Void) -> URLSessionTask? {
        
        let result = onRequest(router)
        if let error = result.error {
            completion(.failure(error))
            return nil
        } else if let model = result.model {
            completion(.success(model as! T))
            return nil
        }
        
        fail()
        return nil
    }
    
    func request(router: EndpointRouter, completion: @escaping (Result<Void, MBError>) -> Void) -> URLSessionTask? {
        let result = onRequest(router)
        if let error = result.error {
            completion(.failure(error))
            return nil
        } else {
            completion(.success(()))
            return nil
        }
    }
    
    func request(router: EndpointRouter, completion: @escaping (Result<Data, MBError>) -> Void) -> URLSessionTask? {
        let result = onDataRequest(router)
        if let error = result.error {
            completion(.failure(error))
            return nil
        } else if let data = result.data {
            completion(.success(data))
            return nil
        }

        fail()
        return nil
    }
    
    func request<T>(router: EndpointRouter, completion: @escaping (Result<(value: T, headers: [AnyHashable : Any]), MBError>) -> Void) -> URLSessionTask? where T : Decodable {
        let result = onRequest(router)
        if let error = result.error {
            completion(.failure(error))
            return nil
        } else if let model = result.model {
            completion(.success((model as! T, returnHeaders)))
            return nil
        }
        
        fail()
        return nil
    }
}

extension MockNetworking: NetworkingImage {
    func request(router: EndpointRouter, completion: @escaping (Result<(value: Data, eTag: String?), MBError>) -> Void) -> URLSessionTask? {
        fail()
        return nil
    }
    
    func request(router: EndpointRouter, completion: @escaping (Result<UIImage, MBError>) -> Void) -> URLSessionTask? {
        fail()
        return nil
    }
}

extension MockNetworking: NetworkingUpload {
    func upload(urlReqeust: URLRequest, data: Data, completion: @escaping (Result<Void, MBError>) -> Void) -> URLSessionTask? {
        if let onUpload = onUpload {
            completion(onUpload)
            return nil
        } else {
            completion(.failure(.init(description: nil, type: .unknown)))
            return nil
        }
    }
}
