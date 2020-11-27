//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

public protocol DealerServiceRepresentable {
    
    /// Fetch the outlets
    ///
    /// - Parameters:
    ///   - requestModel: DealerSearchRequestModel with specific kind of search
    ///   - completion: closure with DealersResult
    func fetchDealers(requestModel: DealerSearchRequestModel, completion: @escaping DealerService.DealersResult)
}

public extension DealerServiceRepresentable {
    func fetchDealers(requestModel: DealerSearchRequestModel, completion: @escaping DealerService.DealersResult) {}
}
