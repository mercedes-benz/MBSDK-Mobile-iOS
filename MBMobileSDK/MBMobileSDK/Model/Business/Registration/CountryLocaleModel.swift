//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of country locale
public struct CountryLocaleModel: Codable, Equatable {
    
    public let localeCode: String
    public let localeName: String
    
    public init(localeCode: String, localeName: String) {
        self.localeCode = localeCode
        self.localeName = localeName
    }
}
