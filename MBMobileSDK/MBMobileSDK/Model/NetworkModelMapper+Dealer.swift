//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - Dealer Search

extension NetworkModelMapper {
	
	// MARK: BusinessModel
	
	static func map(apiDealerSearchAddressModel: APIDealerSearchAddressModel?) -> DealerSearchAddressModel {
		return DealerSearchAddressModel(street: apiDealerSearchAddressModel?.street,
										zipCode: apiDealerSearchAddressModel?.zipCode,
										city: apiDealerSearchAddressModel?.city)
	}
	
	static func map(apiDealerSearchOpeningModel: APIDealerSearchOpeningModel?) -> DealerOpeningStatus {
		
		guard apiDealerSearchOpeningModel?.status == .open else {
			return .closed
		}
		return .open(from: apiDealerSearchOpeningModel?.periods.last?.from, until: apiDealerSearchOpeningModel?.periods.last?.until)
	}
	
	static func map(apiDealerSearchOpeningDaysModel: APIDealerSearchOpeningDaysModel?) -> DealerOpeningStatus {
		
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "en_EN")
        dateFormater.dateFormat = DateFormat.weekDayName
		let weekDayName = dateFormater.string(from: Date())
        
		switch weekDayName {
		case "Monday": 		return self.map(apiDealerSearchOpeningModel: apiDealerSearchOpeningDaysModel?.monday)
		case "Tuesday":		return self.map(apiDealerSearchOpeningModel: apiDealerSearchOpeningDaysModel?.tuesday)
		case "Wednesday":	return self.map(apiDealerSearchOpeningModel: apiDealerSearchOpeningDaysModel?.wednesday)
		case "Thursday":	return self.map(apiDealerSearchOpeningModel: apiDealerSearchOpeningDaysModel?.thursday)
		case "Friday":		return self.map(apiDealerSearchOpeningModel: apiDealerSearchOpeningDaysModel?.friday)
		case "Saturday":	return self.map(apiDealerSearchOpeningModel: apiDealerSearchOpeningDaysModel?.saturday)
		case "Sunday":		return self.map(apiDealerSearchOpeningModel: apiDealerSearchOpeningDaysModel?.sunday)
		default:			return .closed
		}
	}
	
	static func map(apiDealerSearchDealerModels: [APIDealerSearchDealerModel]) -> [DealerSearchDealerModel] {
		return apiDealerSearchDealerModels.map { self.map(apiDealerSearchDealerModel: $0) }
	}
	
    static func map(apiDealerSearchDealerModel: APIDealerSearchDealerModel) -> DealerSearchDealerModel {

		let coordinate: CoordinateModel? = {
			guard let apiCoordinate = apiDealerSearchDealerModel.coordinate else {
				return nil
			}
			return CoordinateModel(latitude: apiCoordinate.latitude, longitude: apiCoordinate.longitude)
		}()
		
        return DealerSearchDealerModel(address: self.map(apiDealerSearchAddressModel: apiDealerSearchDealerModel.address),
									   coordinate: coordinate,
									   name: apiDealerSearchDealerModel.legalName,
									   openingHour: self.map(apiDealerSearchOpeningDaysModel: apiDealerSearchDealerModel.openingHours),
                                       phone: apiDealerSearchDealerModel.phone,
                                       id: apiDealerSearchDealerModel.id)
    }
	
	
	// MARK: NetworkModel
	
    static func map(dealerSearchRequestModel: DealerSearchRequestModel) -> APIDealerSearchRequestModel {

        let searchArea = { () -> APIDealerSearchSearchAreaRequestModel? in

            if let location = dealerSearchRequestModel.location, let radius = dealerSearchRequestModel.radius {

                let centerModel = self.map(dealerSearchCoordinateModel: location)
                let radiusModel = APIDealerSearchRadiusModel(value: String(radius), unit: .km)

                return APIDealerSearchSearchAreaRequestModel(center: centerModel, radius: radiusModel)
            }

            return nil
        }()

        return APIDealerSearchRequestModel(zipCodeOrCityName: dealerSearchRequestModel.zipCode,
                                           countryIsoCode: dealerSearchRequestModel.countryIsoCode,
                                           searchArea: searchArea,
                                           brandCode: dealerSearchRequestModel.brandCode,
                                           productGroup: dealerSearchRequestModel.productGroup,
                                           activity: dealerSearchRequestModel.activity)
    }

    static func map(dealerSearchCoordinateModel: CoordinateModel) -> APIDealerSearchCoordinateRequestModel {
        return APIDealerSearchCoordinateRequestModel(
            latitude: String(dealerSearchCoordinateModel.latitude),
            longitude: String(dealerSearchCoordinateModel.longitude)
        )
    }
}


// MARK: - Dealer for Vehicle Mapping

extension NetworkModelMapper {

	// MARK: NetworkModel

	static func map(dealerItemModel: VehicleDealerItemModel) -> APIVehicleDealerItemModel {
		return APIVehicleDealerItemModel(dealerId: dealerItemModel.dealerId,
										 role: dealerItemModel.role,
										 updatedAt: nil,
										 dealerData: self.map(dealerMerchantModel: dealerItemModel.merchant))
	}

	static func map(dealerUpdateModel: VehicleDealerUpdateModel) -> APIVehicleDealerUpdateModel {
		return APIVehicleDealerUpdateModel(dealerId: dealerUpdateModel.dealerId,
										   role: dealerUpdateModel.role)
	}

	static func map(dealerUpdateModels: [VehicleDealerUpdateModel]) -> [APIVehicleDealerUpdateModel] {
		return dealerUpdateModels.map { self.map(dealerUpdateModel: $0) }
	}

	static func map(dealerItemModels: [VehicleDealerItemModel]) -> [APIVehicleDealerItemModel] {
		return dealerItemModels.map { self.map(dealerItemModel: $0) }
	}

	static func map(dealerMerchantModel: DealerMerchantModel?) -> APIDealerMerchantModel? {

		guard let merchant = dealerMerchantModel else {
			return nil
		}

		return APIDealerMerchantModel(legalName: merchant.legalName,
									  address: nil,
									  openingHours: nil)
	}


	// MARK: BusinessModel

	static func map(apiVehicleDealerItemsModel: APIVehicleDealerItemsModel?) -> [VehicleDealerItemModel] {
		return apiVehicleDealerItemsModel?.items.compactMap { VehicleDealerItemModel(dealerId: $0.dealerId,
																					 role: $0.role,
																					 merchant: self.map(apiDealerMerchantModel: $0.dealerData)) } ?? []
	}

	private static func map(apiDealerMerchantModel: APIDealerMerchantModel?) -> DealerMerchantModel? {

		guard let merchant = apiDealerMerchantModel else {
			return nil
		}

		return DealerMerchantModel(legalName: merchant.legalName,
								   address: self.map(apiDealerAddress: merchant.address),
								   openingHours: self.map(apiDealerOpeningHours: merchant.openingHours))
	}

	private static func map(apiDealerAddress: APIDealerAddressModel?) -> DealerAddressModel? {

		guard let address = apiDealerAddress else {
			return nil
		}

		return DealerAddressModel(street: address.street,
								  addressAddition: address.addressAddition,
								  zipCode: address.zipCode,
								  city: address.city,
								  district: address.district,
								  countryIsoCode: address.countryIsoCode)
	}

	private static func map(apiDealerOpeningHours: APIDealerOpeningHoursModel?) -> DealerOpeningHoursModel? {

		guard let openingHours = apiDealerOpeningHours else {
			return nil
		}

		return DealerOpeningHoursModel(monday: self.map(apiDealerOpeningDay: openingHours.monday),
									   tuesday: self.map(apiDealerOpeningDay: openingHours.tuesday),
									   wednesday: self.map(apiDealerOpeningDay: openingHours.wednesday),
									   thursday: self.map(apiDealerOpeningDay: openingHours.thursday),
									   friday: self.map(apiDealerOpeningDay: openingHours.friday),
									   saturday: self.map(apiDealerOpeningDay: openingHours.saturday),
									   sunday: self.map(apiDealerOpeningDay: openingHours.sunday))
	}

	private static func map(apiDealerOpeningDay: APIDealerOpeningDayModel?) -> DealerOpeningDay? {

		guard let openingDay = apiDealerOpeningDay else {
			return nil
		}

		guard openingDay.status == .open else {
			return DealerOpeningDay(status: .closed)
		}
		return DealerOpeningDay(status: .open(from: openingDay.periods.last?.from, until: openingDay.periods.last?.until))
	}
    
	static func map(apiSendToCarCapabilities: APISendToCarCapabilitiesModel, finOrVin: String) -> SendToCarCapabilitiesModel {
		return SendToCarCapabilitiesModel(capabilities: apiSendToCarCapabilities.capabilities.compactMap { SendToCarCapability(rawValue: $0) },
										  finOrVin: finOrVin,
										  preconditions: apiSendToCarCapabilities.preconditions.compactMap { SendToCarPrecondition(rawValue: $0) })
    }
}
