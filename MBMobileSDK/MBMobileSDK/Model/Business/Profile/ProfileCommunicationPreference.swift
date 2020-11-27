//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of communication Preferences
public enum  ProfileCommunicationPreference: String {
    case phone                      = "contactedByPhone"
    case sms                        = "contactedBySms"
    case letter                     = "contactedByLetter"
    case email                      = "contactedByEmail"
}
