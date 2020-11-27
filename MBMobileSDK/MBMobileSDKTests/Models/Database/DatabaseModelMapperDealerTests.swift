//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import XCTest
import RealmSwift

@testable import MBMobileSDK

class DatabaseModelMapperDealerTests: XCTestCase {

    private struct Constants {
        static let dealerRole: DealerRole = .sales
        static let dealerId: String = "dealer_id"
        static let merchantLegalName: String = "merchant_legal_name"
        static let dealerAddressStreet: String = "dealer_street"
        static let dealerAddressAddition: String = "dealer_address_addition"
        static let dealerAddressDistrict: String = "dealer_district"
        static let dealerAddressCity: String = "dealer_city"
        static let dealerAddressZipCode: String = "dealer_zip_code"
        static let dealerAddressCountryIsoCode: String = "dealer_country_iso_code"
        static let dealerOpeningHoursMondayStatus: String = "OPEN"
        static let dealerOpeningHoursThursdayStatus: String = "CLOSE"
        static let dealerOpeningHoursSundayStatus: String = "OPEN"
        static let dealerDayPeriodMondayFrom: String = "08:00"
        static let dealerDayPeriodMondayUntil: String = "17:00"
        static let dealerDayPeriodSundayFirstFrom: String = "10:00"
        static let dealerDayPeriodSundayFirstUntil: String = "12:00"
        static let dealerDayPeriodSundaySecondFrom: String = "14:00"
        static let dealerDayPeriodSundaySecondUntil: String = "16:00"
    }

	private let mapper = VehicleDbModelMapper()
	
    // MARK: - Tests

    func testMapDbVehicleDealerItemList() {
		
        let dealerModel = DBVehicleDealerItemModel()
        dealerModel.role = Constants.dealerRole.rawValue
        dealerModel.dealerId = Constants.dealerId
        dealerModel.merchant = createDbDealerMerchantModel()
        let dealerModelList = List<DBVehicleDealerItemModel>()
        dealerModelList.append(dealerModel)

		let mappedDealerModelArray = self.mapper.map(dealerModelList)
        XCTAssertEqual(mappedDealerModelArray.count, 1)

        let mappedDealerModel = mappedDealerModelArray.first
        XCTAssertEqual(mappedDealerModel?.dealerId, Constants.dealerId)
        XCTAssertEqual(mappedDealerModel?.role, Constants.dealerRole)

        let mappedDealerMerchantModel = mappedDealerModel?.merchant
        XCTAssertNotNil(mappedDealerMerchantModel)

        let mappedDealerAddressModel = mappedDealerMerchantModel?.address
        XCTAssertNotNil(mappedDealerAddressModel)
        XCTAssertEqual(mappedDealerAddressModel?.zipCode, Constants.dealerAddressZipCode)
        XCTAssertEqual(mappedDealerAddressModel?.street, Constants.dealerAddressStreet)
        XCTAssertEqual(mappedDealerAddressModel?.district, Constants.dealerAddressDistrict)
        XCTAssertEqual(mappedDealerAddressModel?.countryIsoCode, Constants.dealerAddressCountryIsoCode)
        XCTAssertEqual(mappedDealerAddressModel?.city, Constants.dealerAddressCity)
        XCTAssertEqual(mappedDealerAddressModel?.addressAddition, Constants.dealerAddressAddition)

        let mappedDealerOpeningHoursModel = mappedDealerMerchantModel?.openingHours
        XCTAssertNotNil(mappedDealerOpeningHoursModel)
        XCTAssertNil(mappedDealerOpeningHoursModel?.tuesday?.status)
        XCTAssertNil(mappedDealerOpeningHoursModel?.wednesday?.status)
        XCTAssertNil(mappedDealerOpeningHoursModel?.friday?.status)
        XCTAssertNil(mappedDealerOpeningHoursModel?.saturday?.status)

        let mappedOpeningDayMonday = mappedDealerOpeningHoursModel?.monday
        let mondayStatus = mappedOpeningDayMonday?.status
        XCTAssertNotNil(mondayStatus)
		
        switch (mondayStatus!) {
        case DealerOpeningStatus.closed:
            XCTFail()
			
        case DealerOpeningStatus.open(let from, let until):
            XCTAssertEqual(from, Constants.dealerDayPeriodMondayFrom)
            XCTAssertEqual(until, Constants.dealerDayPeriodMondayUntil)
        }

        let mappedOpeningDayThursday = mappedDealerOpeningHoursModel?.thursday
        let thursdayStatus = mappedOpeningDayThursday?.status
        XCTAssertNotNil(thursdayStatus)
		
        switch (thursdayStatus!) {
        case DealerOpeningStatus.closed:
            break
			
        case DealerOpeningStatus.open(_, _):
            XCTFail()
        }

        let mappedOpeningDaySunday = mappedDealerOpeningHoursModel?.sunday
        let sundayStatus = mappedOpeningDaySunday?.status
        XCTAssertNotNil(sundayStatus)
		
        switch (sundayStatus!) {
        case DealerOpeningStatus.closed:
            XCTFail()
			
        case DealerOpeningStatus.open(let from, let until):
            XCTAssertEqual(from, Constants.dealerDayPeriodSundaySecondFrom)
            XCTAssertEqual(until, Constants.dealerDayPeriodSundaySecondUntil)
        }
    }

    func testMapVehicleDealerItemModels() {
		
        let dealerAddressModel = DealerAddressModel(street: Constants.dealerAddressStreet,
													addressAddition: Constants.dealerAddressAddition,
													zipCode: Constants.dealerAddressZipCode,
													city: Constants.dealerAddressCity,
													district: Constants.dealerAddressDistrict,
													countryIsoCode: Constants.dealerAddressCountryIsoCode)
        let dealerMerchantModel = DealerMerchantModel(legalName: Constants.merchantLegalName,
													  address: dealerAddressModel,
													  openingHours: createDealerOpeningHoursModel())
        let dealerItemModel = VehicleDealerItemModel(dealerId: Constants.dealerId,
													 role: Constants.dealerRole,
													 merchant: dealerMerchantModel)

		let mappedDealerModelArray = self.mapper.map([dealerItemModel])
        XCTAssertEqual(mappedDealerModelArray.count, 1)
        let mappedDealerModel = mappedDealerModelArray.first
        XCTAssertNotNil(mappedDealerModel)
        XCTAssertEqual(mappedDealerModel?.dealerId, Constants.dealerId)
        XCTAssertEqual(mappedDealerModel?.role, Constants.dealerRole.rawValue)

        let mappedMerchantModel = mappedDealerModel?.merchant
        XCTAssertNotNil(mappedMerchantModel)
        XCTAssertEqual(mappedMerchantModel?.legalName, Constants.merchantLegalName)

        let mappedAddressModel = mappedMerchantModel?.address
        XCTAssertNotNil(mappedAddressModel)
        XCTAssertEqual(mappedAddressModel?.addressAddition, Constants.dealerAddressAddition)
        XCTAssertEqual(mappedAddressModel?.city, Constants.dealerAddressCity)
        XCTAssertEqual(mappedAddressModel?.countryIsoCode, Constants.dealerAddressCountryIsoCode)
        XCTAssertEqual(mappedAddressModel?.district, Constants.dealerAddressDistrict)
        XCTAssertEqual(mappedAddressModel?.street, Constants.dealerAddressStreet)
        XCTAssertEqual(mappedAddressModel?.zipCode, Constants.dealerAddressZipCode)

        let mappedOpeningHoursModel = mappedMerchantModel?.openingHours
        XCTAssertNotNil(mappedOpeningHoursModel)
        XCTAssertNil(mappedOpeningHoursModel?.tuesday)
        XCTAssertNil(mappedOpeningHoursModel?.wednesday)
        XCTAssertNil(mappedOpeningHoursModel?.friday)
        XCTAssertNil(mappedOpeningHoursModel?.saturday)

        let mappedMonday = mappedOpeningHoursModel?.monday
        XCTAssertNotNil(mappedMonday)
        XCTAssertEqual(mappedMonday?.status, Constants.dealerOpeningHoursMondayStatus)
        XCTAssertEqual(mappedMonday?.periods.count, 1)
        let mappedMondayPeriod = mappedMonday?.periods.first
        XCTAssertEqual(mappedMondayPeriod?.from, Constants.dealerDayPeriodMondayFrom)
        XCTAssertEqual(mappedMondayPeriod?.until, Constants.dealerDayPeriodMondayUntil)

        let mappedThursday = mappedOpeningHoursModel?.thursday
        XCTAssertNotNil(mappedThursday)
        XCTAssertEqual(mappedThursday?.status, Constants.dealerOpeningHoursThursdayStatus)
        XCTAssertTrue(mappedThursday?.periods.isEmpty ?? false)

        let mappedSunday = mappedOpeningHoursModel?.sunday
        XCTAssertNotNil(mappedSunday)
        XCTAssertEqual(mappedSunday?.status, Constants.dealerOpeningHoursSundayStatus)
        XCTAssertEqual(mappedSunday?.periods.count, 1)
        let mappedSundayPeriod = mappedSunday?.periods.first
        XCTAssertEqual(mappedSundayPeriod?.from, Constants.dealerDayPeriodSundaySecondFrom)
        XCTAssertEqual(mappedSundayPeriod?.until, Constants.dealerDayPeriodSundaySecondUntil)
    }

	
    // MARK: - Helpers

    private func createDbDealerMerchantModel() -> DBDealerMerchantModel {
		
        let merchantModel = DBDealerMerchantModel()
        merchantModel.legalName = Constants.merchantLegalName
        merchantModel.address = createDbDealerAddressModel()
        merchantModel.openingHours = createDbDealerOpeningHoursModel()
        return merchantModel
    }

    private func createDbDealerAddressModel() -> DBDealerAddressModel {
		
        let dealerAddressModel = DBDealerAddressModel()
        dealerAddressModel.street = Constants.dealerAddressStreet
        dealerAddressModel.addressAddition = Constants.dealerAddressAddition
        dealerAddressModel.district = Constants.dealerAddressDistrict
        dealerAddressModel.city = Constants.dealerAddressCity
        dealerAddressModel.zipCode = Constants.dealerAddressZipCode
        dealerAddressModel.countryIsoCode = Constants.dealerAddressCountryIsoCode
        return dealerAddressModel
    }

    private func createDbDealerOpeningHoursModel() -> DBDealerOpeningHoursModel {
		
        let dealerOpeningHoursModel = DBDealerOpeningHoursModel()
        dealerOpeningHoursModel.monday = createDbOpeningDayModelMonday()
        dealerOpeningHoursModel.thursday = createDbOpeningDayModelThursday()
        dealerOpeningHoursModel.sunday = createDbOpeningDayModelSunday()
        return dealerOpeningHoursModel
    }

    private func createDbOpeningDayModelMonday() -> DBDealerOpeningDayModel {
		
        let mondayPeriod = DBDealerDayPeriodModel()
        mondayPeriod.from = Constants.dealerDayPeriodMondayFrom
        mondayPeriod.until = Constants.dealerDayPeriodMondayUntil
        let mondayModel = DBDealerOpeningDayModel()
        mondayModel.status = Constants.dealerOpeningHoursMondayStatus
        mondayModel.periods.append(mondayPeriod)
        return mondayModel
    }

    private func createDbOpeningDayModelThursday() -> DBDealerOpeningDayModel {
		
        let thursdayModel = DBDealerOpeningDayModel()
        thursdayModel.status = Constants.dealerOpeningHoursThursdayStatus
        return thursdayModel
    }

    private func createDbOpeningDayModelSunday() -> DBDealerOpeningDayModel {
		
        let sundayFirstPeriod = DBDealerDayPeriodModel()
        sundayFirstPeriod.from = Constants.dealerDayPeriodSundayFirstFrom
        sundayFirstPeriod.until = Constants.dealerDayPeriodSundayFirstUntil
		
        let sundaySecondPeriod = DBDealerDayPeriodModel()
        sundaySecondPeriod.from = Constants.dealerDayPeriodSundaySecondFrom
        sundaySecondPeriod.until = Constants.dealerDayPeriodSundaySecondUntil
		
        let sundayModel = DBDealerOpeningDayModel()
        sundayModel.status = Constants.dealerOpeningHoursMondayStatus
        sundayModel.periods.append(sundayFirstPeriod)
        sundayModel.periods.append(sundaySecondPeriod)
        return sundayModel
    }

    private func createDealerOpeningHoursModel() -> DealerOpeningHoursModel {
		
        let monday = DealerOpeningDay(status: DealerOpeningStatus.open(from: Constants.dealerDayPeriodMondayFrom,
																	   until: Constants.dealerDayPeriodMondayUntil))
        let thursday = DealerOpeningDay(status: DealerOpeningStatus.closed)
        let sunday = DealerOpeningDay(status: DealerOpeningStatus.open(from: Constants.dealerDayPeriodSundaySecondFrom,
																	   until: Constants.dealerDayPeriodSundaySecondUntil))

        return DealerOpeningHoursModel(monday: monday,
									   tuesday: nil,
									   wednesday: nil,
									   thursday: thursday,
									   friday: nil,
									   saturday: nil, sunday: sunday)
    }
}
