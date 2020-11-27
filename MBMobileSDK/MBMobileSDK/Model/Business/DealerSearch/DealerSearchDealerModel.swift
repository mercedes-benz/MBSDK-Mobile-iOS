//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import Contacts

/// Representation of a dealer search item
public struct DealerSearchDealerModel {

	let address: DealerSearchAddressModel
	public let coordinate: CoordinateModel?
    public let name: String
	public let openingHour: DealerOpeningStatus
    public let phone: String?
    public let id: String
	
    public var addressFormatted: String {
        guard let street = address.street,
              let city = address.city,
              let zip = address.zipCode else {
            return ""
        }
        
        let addr = CNMutablePostalAddress()
        addr.city = city
        addr.street = street
        addr.postalCode = zip
        return CNPostalAddressFormatter.string(from: addr, style: .mailingAddress)
    }
}
