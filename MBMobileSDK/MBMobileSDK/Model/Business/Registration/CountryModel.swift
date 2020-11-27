//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of country
public struct CountryModel: Codable, Equatable {
    
    public let availability: Bool
    public let countryCode: String
    public let countryName: String
    public let instance: String
    public let legalRegion: String
    public let locales: [CountryLocaleModel]
    public let natconCountry: Bool
    
    public init(availability: Bool, countryCode: String, countryName: String, instance: String, legalRegion: String, locales: [CountryLocaleModel], natconCountry: Bool) {
        self.availability = availability
        self.countryCode = countryCode
        self.countryName = countryName
        self.instance = instance
        self.legalRegion = legalRegion
        self.locales = locales
        self.natconCountry = natconCountry
    }
}


// MARK: - Extension

public extension CountryModel {
	
	var isNatConCountry: Bool {
		return self.natconCountry
	}
}
