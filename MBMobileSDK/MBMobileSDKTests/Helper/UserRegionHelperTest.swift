//
//  Copyright © 2020 Daimler AG. All rights reserved.
//

import Quick
import Nimble

import MBCommonKit

@testable import MBMobileSDK

class UserRegionHelperTest: QuickSpec {

    override func spec() {
        var userRegionHelper: UserRegionHelper!
        var mockLocaleProviding: MockLocaleProviding!
            
        beforeEach {
            mockLocaleProviding = MockLocaleProviding()
            userRegionHelper = UserRegionHelper(localeProvider: mockLocaleProviding)
        }
        
        describe("locale for user") {
            it("should return the preferredLanguageCode of the user if available") {
                let locale = userRegionHelper.locale(for: self.testUser())
                expect(locale) == self.testUser().preferredLanguageCode
            }
            
            it("should return the fallback if the preferredLanguageCode is empty") {
                let locale = userRegionHelper.locale(for: self.testUser(preferredLanguageCode: ""))
                expect(locale) == "testLocale"
            }
            
            it("should return the fallback if user preferredLanguageCode is not available") {
                let locale = userRegionHelper.locale(for: nil)
                expect(locale) == "testLocale"
            }
        }
        
        
        describe("countryCode for user") {
            it("should return the preferredLanguageCode of the user if available") {
                let countryCode = userRegionHelper.countryCode(for: self.testUser())
                expect(countryCode) == self.testUser().accountCountryCode
            }
            
            it("should return the fallback if the preferredLanguageCode is empty") {
                let countryCode = userRegionHelper.countryCode(for: self.testUser(accountCountryCode: ""))
                expect(countryCode) == "testCountryCode"
            }
            
            it("should return the fallback if user preferredLanguageCode is not available") {
                let countryCode = userRegionHelper.countryCode(for: nil)
                expect(countryCode) == "testCountryCode"
            }
        }
        
        
    }

    private func testUser(preferredLanguageCode: String = "de",
                          accountCountryCode: String = "DE") -> UserModel {
        return UserModelHelper.build(preferredLanguageCode: preferredLanguageCode,
                                     accountCountryCode: accountCountryCode)
    }
    
    class MockLocaleProviding: LocaleProviding {
        var locale: String = "testLocale"
        var languageCode: String = ""
        var regionCode: String = "testCountryCode"
    }
}
