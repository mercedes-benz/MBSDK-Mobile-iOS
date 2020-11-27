//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBCommonKit

class MockLocaleProviding: LocaleProviding {
    
    static let localeMockValue = "mockLocale"
    static let languageMockCodeValue = "mockLanguageCode"
    static let regionMockCodeValue = "mockRegionCode"
    
    var locale: String = MockLocaleProviding.localeMockValue
    var languageCode: String = MockLocaleProviding.languageMockCodeValue
    var regionCode: String = MockLocaleProviding.regionMockCodeValue
}
