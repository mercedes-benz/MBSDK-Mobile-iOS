//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation for the status update of a service activation
public struct VehicleServiceStatusUpdateModel {
	
	public let id: Int
	public let status: ServiceActivationStatus

    // MARK: - Init

    public init(id: Int, status: ServiceActivationStatus) {

        self.id = id
        self.status = status
    }
}
