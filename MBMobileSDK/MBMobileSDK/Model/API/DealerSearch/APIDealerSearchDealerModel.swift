//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIDealerSearchDealerModel: Decodable {

    enum CodingKeys: String, CodingKey {
        case address
        case coordinate = "geoCoordinates"
        case communication
		case id
		case legalName
		case openingHours
    }

    enum CommunicationCodingKeys: String, CodingKey {
        case phone
    }

	let address: APIDealerSearchAddressModel?
	let coordinate: APIDealerSearchCoordinateModel?
	let id: String
    let legalName: String
	let openingHours: APIDealerSearchOpeningDaysModel?
    let phone: String?

	
	// MARK: - Init
	
    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
		let communicationContainer = try? container.nestedContainer(keyedBy: CommunicationCodingKeys.self, forKey: .communication)
		
		self.address      = try container.decode(APIDealerSearchAddressModel.self, forKey: .address)
		self.coordinate   = try container.decodeIfPresent(APIDealerSearchCoordinateModel.self, forKey: .coordinate)
		// TODO: remove optional parsing of attribute
		self.id           = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
		self.legalName    = try container.decode(String.self, forKey: .legalName)
		self.openingHours = try container.decodeIfPresent(APIDealerSearchOpeningDaysModel.self, forKey: .openingHours)
		self.phone        = try communicationContainer?.decodeIfPresent(String.self, forKey: .phone)
    }
}
