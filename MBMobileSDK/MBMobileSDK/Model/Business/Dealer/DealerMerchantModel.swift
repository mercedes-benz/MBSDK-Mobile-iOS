//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public struct DealerMerchantModel {

    public let legalName: String?
    public let address: DealerAddressModel?
    public let openingHours: DealerOpeningHoursModel?
}

public struct DealerAddressModel {

    public let street: String?
    public let addressAddition: String?
    public let zipCode: String?
    public let city: String?
    public let district: String?
    public let countryIsoCode: String?

    public var addressFormatted: String {
        return self.street ?? self.city ?? ""
    }
}

public struct DealerOpeningHoursModel {

	public var monday: DealerOpeningDay?
	public var tuesday: DealerOpeningDay?
	public var wednesday: DealerOpeningDay?
	public var thursday: DealerOpeningDay?
	public var friday: DealerOpeningDay?
	public var saturday: DealerOpeningDay?
	public var sunday: DealerOpeningDay?

	public var today: DealerOpeningDay? {

		let weekday = Calendar.current.component(.weekday, from: Date())

        switch weekday {
        case 1:        return self.sunday
        case 2:        return self.monday
        case 3:        return self.tuesday
        case 4:        return self.wednesday
        case 5:        return self.thursday
        case 6:        return self.friday
        case 7:        return self.saturday
        default:       return nil
        }
	}
}

public struct DealerOpeningDay {
    public let status: DealerOpeningStatus?
}
