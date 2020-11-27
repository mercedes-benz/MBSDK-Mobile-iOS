//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APICountryModel: Codable {
    
    let availability: Bool
    let countryCode: String
    let countryName: String
    let instance: String
    let legalRegion: String
    let locales: [APICountryLocaleModel]?
	let natconCountry: Bool
}
