//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit

public protocol UserRegionHelping {
    func locale(for user: UserModel?) -> String
    func countryCode(for user: UserModel?) -> String
}

public struct UserRegionHelper: UserRegionHelping {
    
    private let localeProvider: LocaleProviding
    
    public init(localeProvider: LocaleProviding = MBLocaleProvider()) {
        self.localeProvider = localeProvider
    }
    
    public func locale(for user: UserModel?) -> String {
                
        if let preferredLanguageCode = user?.preferredLanguageCode,
            !preferredLanguageCode.isEmpty {
            return preferredLanguageCode
        }
        
        return self.localeProvider.locale
    }
    
    public func countryCode(for user: UserModel?) -> String {
        
        if let accountCountryCode = user?.accountCountryCode,
            !accountCountryCode.isEmpty {
            return accountCountryCode
        }
        
		return self.localeProvider.regionCode
    }
}
