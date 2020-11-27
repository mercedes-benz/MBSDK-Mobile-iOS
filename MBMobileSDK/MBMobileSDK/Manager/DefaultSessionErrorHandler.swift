//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

class DefaultSessionErrorHandler: SessionErrorHandling {
	
    func handleRefreshError(_ error: MBError) {
        LOG.E(error)
    }
}
