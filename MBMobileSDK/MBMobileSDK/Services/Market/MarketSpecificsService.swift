//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

public enum MarketSpecificsError: Error {
    case network(MBError)
}

public protocol MarketsServiceRepresentable {
    
    /// Fetches the profile fields of a user from bff
    func fetchProfileFields(countryCode: String, locale: String, completion: @escaping (Result<[ProfileFieldModel], MarketSpecificsError>) -> Void)
    
    /// Fetches the list of supported countries from bff
    func fetchCountries(completion: @escaping (Result<[CountryModel], MarketSpecificsError>) -> Void)
}

public class MarketsService: MarketsServiceRepresentable {
    
    private let networking: Networking
    
    public convenience init() {
        self.init(networking: NetworkService())
    }
    
    public init(networking: Networking) {
        self.networking = networking
    }
    
    public func fetchProfileFields(countryCode: String, locale: String, completion: @escaping (Result<[ProfileFieldModel], MarketSpecificsError>) -> Void) {
        
        let router = BffEndpointRouter.profileFields(countryCode: countryCode, locale: locale)
        self.networking.request(router: router, keyPath: "customerDataFields") { (result: Result<[ProfileFieldModel], MBError>) in

            switch result {
                
            case .failure(let error):
                completion(.failure(.network(error)))
            case .success(let profileFields):
                completion(.success(profileFields))
            }
        }
    }
    
    public func fetchCountries(completion: @escaping (Result<[CountryModel], MarketSpecificsError>) -> Void) {
        
        let router = BffEndpointRouter.countries
        self.networking.request(router: router) { (result: Result<[APICountryModel], MBError>) in

            switch result {
            case .failure(let error):
                completion(.failure(.network(error)))

            case .success(let apiCountries):
                let countries = NetworkModelMapper.map(apiCountries: apiCountries)
                completion(.success(countries))
            }
        }
    }
    
}
