//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// The possible service missing fields for service activation
public enum ServiceMissingFields: String, Codable {

    case licencePlate = "licencePlate"
    case vehicleServiceDealer = "vehicleServiceDealer"
    case userContactByMail = "userContactedByEmail"
    case userContactByPhone = "userContactedByPhone"
    case userContactBySMS = "userContactedBySms"
    case userContactByLetter = "userContactedByLetter"
    case cpInCredit = "cp.INCREDIT"
    case userMobilePhone = "userMobilePhone"
    case userMobilePhoneVerified = "userMobilePhoneVerified"
    case userMail = "userEmail"
    case userMailVerified = "userEmailVerified"
    case unknown = "unknown"
}
