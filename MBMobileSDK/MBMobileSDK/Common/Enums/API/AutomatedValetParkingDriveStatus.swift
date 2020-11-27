//
//  Copyright © 2020 Daimler AG. All rights reserved.
//

import Foundation

/// Drive stauts of Automated Valet Parking's reservation
public enum AutomatedValetParkingDriveStatus: String, Codable {
    case ready = "READY"
    case inProgress = "IN_PROGRESS"
    case failedRetryPossibleUser = "FAILED_RETRY_POSSIBLE_USER"
    case failedRetryPossibleOperator = "FAILED_RETRY_POSSIBLE_OPERATOR"
    case failed = "FAILED"
    case completed = "COMPLETED"
    case readyForProductLiability = "READY_FOR_PRODUCT_LIABILITY"
    case driveInProgress = "DRIVE_IN_PROGRESS"
    case operatorDriveInProgress = "OPERATOR_DRIVE_IN_PROGRESS"
    case checkOut = "CHECKED_OUT"
    case unknown
}
