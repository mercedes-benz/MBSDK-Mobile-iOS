//
// Copyright (c) 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

public protocol SessionErrorHandling {
    
    ///Handles an error depending on the information contained by the given error object.
    ///
    /// - Parameter error: Contains all information about the occurred error.
    func handleRefreshError(_ error: MBError)
}
