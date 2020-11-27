//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBCommonKit
import MBNetworkKit

/// Service to call all outlet related requests
public class DealerService: DealerServiceRepresentable {

    // MARK: Typealias
    
    /// Completion for dealers request
    public typealias DealersResult = (Result<[DealerSearchDealerModel], MBError>) -> Void

	// MARK: Dependencies
    
	private let networking: Networking
    private let tokenProviding: TokenProviding?
    
    
    // MARK: - Init
    
    convenience init(networking: Networking) {
        self.init(networking: networking,
                  tokenProviding: nil)
    }
    
    init(networking: Networking, tokenProviding: TokenProviding?) {
        
        self.networking = networking
        self.tokenProviding = tokenProviding
    }
	
	
	// MARK: - Public
	
    public func fetchDealers(requestModel: DealerSearchRequestModel, completion: @escaping DealersResult) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let apiSearchRequestModel = NetworkModelMapper.map(dealerSearchRequestModel: requestModel)
                let json        = try? apiSearchRequestModel.toJson()
                let requestDict = json as? [String: Any]
                let router      = BffVehicleRouter.dealers(accessToken: token.accessToken, requestModel: requestDict)

                self.networking.request(router: router) { (result: Result<[APIDealerSearchDealerModel], MBError>) in

                    switch result {
                    case .failure(let error):
                        LOG.E(error.localizedDescription)
                        
                        completion(.failure(error))

                    case .success(let apiServiceModels):
                        LOG.D(apiServiceModels)

                        let serviceModels = NetworkModelMapper.map(apiDealerSearchDealerModels: apiServiceModels)
                        completion(.success(serviceModels))
                    }
                }
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
}
