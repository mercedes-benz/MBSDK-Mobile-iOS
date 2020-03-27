//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import MBIngressKit
import MBNetworkKit

public protocol LoginWorkflowHandling: class {
    func handleSuccess(user: UserExistModel, credential: String)
}
