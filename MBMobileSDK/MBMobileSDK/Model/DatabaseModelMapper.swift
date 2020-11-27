//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit
import RealmSwift

// swiftlint:disable function_body_length

class DatabaseModelMapper {
	
	// MARK: - Helper - BusinessModel - Typealias
	
	private typealias UserAddressTupel = (model: DBUserAddressModel, updated: Bool)
	private typealias UserCommunicationPreferenceTupel = (model: DBUserCommunicationPreferenceModel, updated: Bool)
	typealias UserUnitPreferenceTupel = (model: DBUserUnitPreferenceModel, updated: Bool)
	typealias UserAdaptionValuesTupel = (model: DBUserAdaptionValuesModel?, updated: Bool)
	
	// MARK: - Public - BusinessModel
	
	static func map(dbUserModels: [DBUserModel]) -> [UserModel] {
		return dbUserModels.map { self.map(dbUserModel: $0) }
	}
	
	static func map(dbUserModel: DBUserModel) -> UserModel {
		return UserModel(address: self.map(dbUserAddressModel: dbUserModel.address),
						 birthday: DateFormattingHelper.date(dbUserModel.birthday, format: DateFormat.birthday),
						 ciamId: dbUserModel.ciamId,
						 createdAt: dbUserModel.createdAt,
						 email: dbUserModel.email,
						 firstName: dbUserModel.firstName,
						 lastName1: dbUserModel.lastName1,
                         lastName2: dbUserModel.lastName2 ?? "",
						 landlinePhone: dbUserModel.landlinePhone,
						 mobilePhoneNumber: dbUserModel.mobilePhoneNumber,
						 updatedAt: dbUserModel.updatedAt,
						 accountCountryCode: dbUserModel.accountCountryCode ?? "",
						 userPinStatus: UserPinStatus(rawValue: dbUserModel.userPinStatus ?? "") ?? UserPinStatus.unknown,
						 communicationPreference: self.map(dbUserCommunicationPreferenceModel: dbUserModel.communicationPreference),
                         profileImageData: dbUserModel.profileImageData,
                         profileImageEtag: dbUserModel.profileImageEtag,
                         unitPreferences: self.map(dbUserUnitPreferenceModel: dbUserModel.unitPreference),
                         salutation: dbUserModel.salutationCode,
                         title: dbUserModel.title,
                         taxNumber: dbUserModel.taxNumber,
                         namePrefix: dbUserModel.namePrefix,
                         preferredLanguageCode: dbUserModel.preferredLanguageCode ?? "",
                         middleInitial: dbUserModel.middleInitial,
                         accountIdentifier: nil,
						 adaptionValues: self.map(dbAdaptionValues: dbUserModel.adaptionValues),
						 accountVerified: dbUserModel.accountVerified.value,
                         isEmailVerified: dbUserModel.isEmailVerified,
                         isMobileVerified: dbUserModel.isMobileVerified)
	}
	
	static func map(dbUserUnitPreferenceModel: DBUserUnitPreferenceModel?) -> UserUnitPreferenceModel {
		
		guard let dbUserUnitPreferenceModel = dbUserUnitPreferenceModel else {
			return UserUnitPreferenceModel()
		}
        
		return UserUnitPreferenceModel(clockHours: ClockHoursUnit(rawValue: dbUserUnitPreferenceModel.clockHours) ?? ClockHoursUnit.defaultCase,
									   consumptionCo: ConsumptionCoUnit(rawValue: dbUserUnitPreferenceModel.consumptionCo) ?? ConsumptionCoUnit.defaultCase,
									   consumptionEv: ConsumptionEvUnit(rawValue: dbUserUnitPreferenceModel.consumptionEv) ?? ConsumptionEvUnit.defaultCase,
									   consumptionGas: ConsumptionGasUnit(rawValue: dbUserUnitPreferenceModel.consumptionGas) ?? ConsumptionGasUnit.defaultCase,
									   speedDistance: SpeedDistanceUnit(rawValue: dbUserUnitPreferenceModel.speedDistance) ?? SpeedDistanceUnit.defaultCase,
									   temperature: UserTemperatureUnit(rawValue: dbUserUnitPreferenceModel.temperature) ?? UserTemperatureUnit.defaultCase,
									   tirePressure: TirePressureUnit(rawValue: dbUserUnitPreferenceModel.tirePressure) ?? TirePressureUnit.defaultCase)
	}
    
    static func map(dbAdaptionValues: DBUserAdaptionValuesModel?) -> UserAdaptionValuesModel? {
        
        guard let dbAdaptionValues = dbAdaptionValues else {
            return nil
        }
        
        return UserAdaptionValuesModel(bodyHeight: dbAdaptionValues.bodyHeight.value, preAdjustment: dbAdaptionValues.preAdjustment.value, alias: dbAdaptionValues.alias)
    }
	
	
	// MARK: - Public - DatabaseModel
	
	static func map(userModel: UserModel) -> DBUserModel {
		
		let dbUserModel    = self.map(userModel: userModel, dbUserModel: DBUserModel())
		dbUserModel.ciamId = userModel.ciamId
		return dbUserModel
	}
	
	static func map(userModel: UserModel, dbUserModel: DBUserModel) -> DBUserModel {

		let birthday = DateFormattingHelper.string(userModel.birthday, format: DateFormat.birthday)
		let userAdaptionValuesTupel = self.map(userAdaptionValues: userModel.adaptionValues,
											   dbUserAdaptionValues: dbUserModel.adaptionValues ?? DBUserAdaptionValuesModel())
		let userAddressTupel = self.map(userAddressModel: userModel.address,
										dbUserAddressModel: dbUserModel.address ?? DBUserAddressModel())
		let userCommunicationPreferenceTupel = self.map(userCommunicationPreferenceModel: userModel.communicationPreference,
														dbCommunicationPreferenceModel: dbUserModel.communicationPreference ?? DBUserCommunicationPreferenceModel())
        let userUnitPreferenceTupel = self.map(userUnitPreferenceModel: userModel.unitPreferences,
											   dbUnitPreferenceModel: dbUserModel.unitPreference ?? DBUserUnitPreferenceModel())
		
		let updated = userAddressTupel.updated ||
			dbUserModel.accountCountryCode != userModel.accountCountryCode ||
			dbUserModel.birthday != birthday ||
			dbUserModel.createdAt != userModel.createdAt ||
			dbUserModel.email != userModel.email ||
			dbUserModel.firstName != userModel.firstName ||
			dbUserModel.lastName1 != userModel.lastName1 ||
            dbUserModel.lastName2 != userModel.lastName2 ||
			dbUserModel.landlinePhone != userModel.landlinePhone ||
			dbUserModel.mobilePhoneNumber != userModel.mobilePhoneNumber ||
			dbUserModel.updatedAt != userModel.updatedAt ||
			dbUserModel.userPinStatus != userModel.userPinStatus.rawValue ||
            dbUserModel.preferredLanguageCode != userModel.preferredLanguageCode ||
			userCommunicationPreferenceTupel.updated ||
			userUnitPreferenceTupel.updated ||
            dbUserModel.salutationCode != userModel.salutation ||
            dbUserModel.title != userModel.title ||
            dbUserModel.taxNumber != userModel.taxNumber ||
			dbUserModel.accountVerified.value != userModel.accountVerified ||
            dbUserModel.isEmailVerified != userModel.isEmailVerified ||
            dbUserModel.isMobileVerified != userModel.isMobileVerified ||
            userAdaptionValuesTupel.updated
		
		if updated {
			
			dbUserModel.accountCountryCode      = userModel.accountCountryCode
			dbUserModel.adaptionValues          = userAdaptionValuesTupel.model
			dbUserModel.address                 = userAddressTupel.model
			dbUserModel.birthday                = birthday
			dbUserModel.createdAt               = userModel.createdAt
			dbUserModel.communicationPreference = userCommunicationPreferenceTupel.model
			dbUserModel.email                   = userModel.email
			dbUserModel.firstName               = userModel.firstName
			dbUserModel.lastName1               = userModel.lastName1
            dbUserModel.lastName2               = userModel.lastName2
			dbUserModel.landlinePhone           = userModel.landlinePhone
			dbUserModel.mobilePhoneNumber       = userModel.mobilePhoneNumber
			dbUserModel.updatedAt               = userModel.updatedAt
			dbUserModel.unitPreference          = userUnitPreferenceTupel.model
			dbUserModel.userPinStatus           = userModel.userPinStatus.rawValue
            dbUserModel.preferredLanguageCode   = userModel.preferredLanguageCode
            dbUserModel.salutationCode          = userModel.salutation
            dbUserModel.title                   = userModel.title?.isEmpty == true ? nil : userModel.title
            dbUserModel.taxNumber               = userModel.taxNumber
			dbUserModel.accountVerified.value   = userModel.accountVerified
            dbUserModel.isEmailVerified         = userModel.isEmailVerified
            dbUserModel.isMobileVerified        = userModel.isMobileVerified
		}
		
		return dbUserModel
	}
	
	static func map(userUnitPreferenceModel: UserUnitPreferenceModel, dbUnitPreferenceModel: DBUserUnitPreferenceModel) -> UserUnitPreferenceTupel {
		
		let updated = dbUnitPreferenceModel.clockHours != userUnitPreferenceModel.clockHours.rawValue ||
			dbUnitPreferenceModel.consumptionCo != userUnitPreferenceModel.consumptionCo.rawValue ||
			dbUnitPreferenceModel.consumptionEv != userUnitPreferenceModel.consumptionEv.rawValue ||
			dbUnitPreferenceModel.consumptionGas != userUnitPreferenceModel.consumptionGas.rawValue ||
			dbUnitPreferenceModel.speedDistance != userUnitPreferenceModel.speedDistance.rawValue ||
			dbUnitPreferenceModel.temperature != userUnitPreferenceModel.temperature.rawValue ||
			dbUnitPreferenceModel.tirePressure != userUnitPreferenceModel.tirePressure.rawValue
		
		if updated {
			
			dbUnitPreferenceModel.clockHours     = userUnitPreferenceModel.clockHours.rawValue
			dbUnitPreferenceModel.consumptionCo  = userUnitPreferenceModel.consumptionCo.rawValue
			dbUnitPreferenceModel.consumptionEv  = userUnitPreferenceModel.consumptionEv.rawValue
			dbUnitPreferenceModel.consumptionGas = userUnitPreferenceModel.consumptionGas.rawValue
			dbUnitPreferenceModel.speedDistance  = userUnitPreferenceModel.speedDistance.rawValue
			dbUnitPreferenceModel.temperature    = userUnitPreferenceModel.temperature.rawValue
			dbUnitPreferenceModel.tirePressure   = userUnitPreferenceModel.tirePressure.rawValue
		}
		
		return UserUnitPreferenceTupel(model: dbUnitPreferenceModel, updated: updated)
	}
    
    static func map(userAdaptionValues: UserAdaptionValuesModel?, dbUserAdaptionValues: DBUserAdaptionValuesModel) -> UserAdaptionValuesTupel {
        
		let updated = dbUserAdaptionValues.bodyHeight.value != userAdaptionValues?.bodyHeight ||
			dbUserAdaptionValues.preAdjustment.value != userAdaptionValues?.preAdjustment ||
            dbUserAdaptionValues.alias != userAdaptionValues?.alias
		
		if updated {
			
			dbUserAdaptionValues.bodyHeight.value     = userAdaptionValues?.bodyHeight
			dbUserAdaptionValues.preAdjustment.value  = userAdaptionValues?.preAdjustment
            dbUserAdaptionValues.alias                = userAdaptionValues?.alias
		}
		
        return UserAdaptionValuesTupel(model: dbUserAdaptionValues, updated: updated)
    }
	
	
	// MARK: - Helper - BusinessModel
	
	private static func map(dbUserAddressModel: DBUserAddressModel?) -> UserAddressModel {
		return UserAddressModel(city: dbUserAddressModel?.city,
								countryCode: dbUserAddressModel?.countryCode,
								houseNo: dbUserAddressModel?.houseNo,
								state: dbUserAddressModel?.state,
								street: dbUserAddressModel?.street,
								zipCode: dbUserAddressModel?.zipCode,
                                province: dbUserAddressModel?.province,
                                doorNo: dbUserAddressModel?.doorNo,
                                addressLine1: dbUserAddressModel?.addressLine1,
                                streetType: dbUserAddressModel?.streetType,
                                houseName: dbUserAddressModel?.houseName,
                                floorNo: dbUserAddressModel?.floorNo,
                                addressLine2: dbUserAddressModel?.addressLine2,
                                addressLine3: dbUserAddressModel?.addressLine3,
                                postOfficeBox: dbUserAddressModel?.postOfficeBox)
	}
	
	private static func map(dbUserCommunicationPreferenceModel: DBUserCommunicationPreferenceModel?) -> UserCommunicationPreferenceModel {
		return UserCommunicationPreferenceModel(phone: dbUserCommunicationPreferenceModel?.phone.value,
												letter: dbUserCommunicationPreferenceModel?.letter.value,
												email: dbUserCommunicationPreferenceModel?.mail.value,
												sms: dbUserCommunicationPreferenceModel?.sms.value)
	}
	
	private static func map(userAddressModel: UserAddressModel, dbUserAddressModel: DBUserAddressModel) -> UserAddressTupel {
		
		let updated = dbUserAddressModel.city != userAddressModel.city ||
			dbUserAddressModel.countryCode != userAddressModel.countryCode ||
			dbUserAddressModel.houseNo != userAddressModel.houseNo ||
			dbUserAddressModel.state != userAddressModel.state ||
			dbUserAddressModel.street != userAddressModel.street ||
			dbUserAddressModel.zipCode != userAddressModel.zipCode ||
			dbUserAddressModel.province != userAddressModel.province ||
			dbUserAddressModel.doorNo != userAddressModel.doorNo ||
			dbUserAddressModel.addressLine1 != userAddressModel.addressLine1 ||
			dbUserAddressModel.streetType != userAddressModel.streetType ||
			dbUserAddressModel.houseName != userAddressModel.houseName ||
			dbUserAddressModel.floorNo != userAddressModel.floorNo ||
			dbUserAddressModel.addressLine2 != userAddressModel.addressLine2 ||
			dbUserAddressModel.addressLine3 != userAddressModel.addressLine3 ||
			dbUserAddressModel.postOfficeBox != userAddressModel.postOfficeBox
		
		if updated {
			
			dbUserAddressModel.city        = userAddressModel.city
			dbUserAddressModel.countryCode = userAddressModel.countryCode
			dbUserAddressModel.houseNo     = userAddressModel.houseNo
			dbUserAddressModel.state       = userAddressModel.state
			dbUserAddressModel.street      = userAddressModel.street
			dbUserAddressModel.zipCode     = userAddressModel.zipCode
			dbUserAddressModel.province     = userAddressModel.province
			dbUserAddressModel.doorNo       = userAddressModel.doorNo
			dbUserAddressModel.addressLine1 = userAddressModel.addressLine1
			dbUserAddressModel.streetType   = userAddressModel.streetType
			dbUserAddressModel.houseName    = userAddressModel.houseName
			dbUserAddressModel.floorNo      = userAddressModel.floorNo
			dbUserAddressModel.addressLine2 = userAddressModel.addressLine2
			dbUserAddressModel.addressLine3   = userAddressModel.addressLine3
			dbUserAddressModel.postOfficeBox  = userAddressModel.postOfficeBox
		}
		
		return UserAddressTupel(model: dbUserAddressModel, updated: updated)
	}

	private static func map(userCommunicationPreferenceModel: UserCommunicationPreferenceModel, dbCommunicationPreferenceModel: DBUserCommunicationPreferenceModel) -> UserCommunicationPreferenceTupel {
		
		let updated = dbCommunicationPreferenceModel.letter.value != userCommunicationPreferenceModel.letter ||
			dbCommunicationPreferenceModel.mail.value != userCommunicationPreferenceModel.email ||
			dbCommunicationPreferenceModel.phone.value != userCommunicationPreferenceModel.phone ||
			dbCommunicationPreferenceModel.sms.value != userCommunicationPreferenceModel.sms
		
		if updated {
			
			dbCommunicationPreferenceModel.letter.value = userCommunicationPreferenceModel.letter
			dbCommunicationPreferenceModel.mail.value   = userCommunicationPreferenceModel.email
			dbCommunicationPreferenceModel.phone.value  = userCommunicationPreferenceModel.phone
			dbCommunicationPreferenceModel.sms.value    = userCommunicationPreferenceModel.sms
		}
		
		return UserCommunicationPreferenceTupel(model: dbCommunicationPreferenceModel, updated: updated)
	}
}
