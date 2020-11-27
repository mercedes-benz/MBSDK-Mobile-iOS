//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import MBRealmKit

class UserDbModelMapper: DbModelMapping {
    
    typealias DbModel = DBUserModel
    typealias Model = UserModel
    
    func map(_ dbModel: DBUserModel) -> UserModel {
        
        return UserModel(
            address: self.map(dbModel.address),
            birthday: DateFormattingHelper.date(dbModel.birthday, format: DateFormat.birthday),
            ciamId: dbModel.ciamId,
            createdAt: dbModel.createdAt,
            email: dbModel.email,
            firstName: dbModel.firstName,
            lastName1: dbModel.lastName1,
            lastName2: dbModel.lastName2 ?? "",
            landlinePhone: dbModel.landlinePhone,
            mobilePhoneNumber: dbModel.mobilePhoneNumber,
            updatedAt: dbModel.updatedAt,
            accountCountryCode: dbModel.accountCountryCode ?? "",
            userPinStatus: UserPinStatus(rawValue: dbModel.userPinStatus ?? "") ?? UserPinStatus.unknown,
            communicationPreference: self.map(dbModel.communicationPreference),
            profileImageData: dbModel.profileImageData,
            profileImageEtag: dbModel.profileImageEtag,
            unitPreferences: self.map(dbModel.unitPreference),
            salutation: dbModel.salutationCode,
            title: dbModel.title,
            taxNumber: dbModel.taxNumber,
            namePrefix: dbModel.namePrefix,
            preferredLanguageCode: dbModel.preferredLanguageCode ?? "",
            middleInitial: dbModel.middleInitial,
            accountIdentifier: nil,
            adaptionValues: self.map(dbModel.adaptionValues),
			accountVerified: dbModel.accountVerified.value,
            isEmailVerified: dbModel.isEmailVerified,
            isMobileVerified: dbModel.isMobileVerified)
    }
    
    func map(_ businessModel: UserModel) -> DBUserModel {
        
        return DBUserModel(
            ciamId: businessModel.ciamId,
            firstName: businessModel.firstName,
            lastName1: businessModel.lastName1,
            lastName2: businessModel.lastName2,
            title: businessModel.title,
            namePrefix: businessModel.namePrefix,
            middleInitial: businessModel.middleInitial,
            salutationCode: businessModel.salutation,
            email: businessModel.email,
            landlinePhone: businessModel.landlinePhone,
            mobilePhoneNumber: businessModel.mobilePhoneNumber,
            birthday: DateFormattingHelper.string(businessModel.birthday, format: DateFormat.birthday),
            preferredLanguageCode: businessModel.preferredLanguageCode,
            accountCountryCode: businessModel.accountCountryCode,
            createdAt: businessModel.createdAt,
            updatedAt: businessModel.updatedAt,
            address: self.map(businessModel.address),
            communicationPreference: self.map(businessModel.communicationPreference),
            userPinStatus: businessModel.userPinStatus.rawValue,
            profileImageData: businessModel.profileImageData,
            profileImageEtag: businessModel.profileImageEtag,
            unitPreference: self.map(businessModel.unitPreferences),
            taxNumber: businessModel.taxNumber,
            adaptionValues: self.map(businessModel.adaptionValues),
            accountVerified: businessModel.accountVerified,
            isEmailVerified: businessModel.isEmailVerified,
            isMobileVerified: businessModel.isMobileVerified)
    }
    
    
    // MARK: - Helpers
    
    // MARK: Model -> DBModel
    private func map(_ addressModel: UserAddressModel) -> DBUserAddressModel {
        
        return DBUserAddressModel(countryCode: addressModel.countryCode,
                                  state: addressModel.state,
                                  province: addressModel.province,
                                  street: addressModel.street,
                                  houseNo: addressModel.houseNo,
                                  zipCode: addressModel.zipCode,
                                  city: addressModel.city,
                                  streetType: addressModel.streetType,
                                  houseName: addressModel.houseName,
                                  floorNo: addressModel.floorNo,
                                  doorNo: addressModel.doorNo,
                                  addressLine1: addressModel.addressLine1,
                                  addressLine2: addressModel.addressLine2,
                                  addressLine3: addressModel.addressLine3,
                                  postOfficeBox: addressModel.postOfficeBox)
    }
    
    private func map(_ communicationPreference: UserCommunicationPreferenceModel) -> DBUserCommunicationPreferenceModel {
        
        return DBUserCommunicationPreferenceModel(letter: communicationPreference.letter,
                                                  mail: communicationPreference.email,
                                                  phone: communicationPreference.phone,
                                                  sms: communicationPreference.sms)
    }
    
    private func map(_ userUnitPreferences: UserUnitPreferenceModel) -> DBUserUnitPreferenceModel {
        
        return DBUserUnitPreferenceModel(clockHours: userUnitPreferences.clockHours.rawValue,
                                         consumptionCo: userUnitPreferences.consumptionCo.rawValue,
                                         consumptionEv: userUnitPreferences.consumptionEv.rawValue,
                                         consumptionGas: userUnitPreferences.consumptionGas.rawValue,
                                         speedDistance: userUnitPreferences.speedDistance.rawValue,
                                         temperature: userUnitPreferences.temperature.rawValue,
                                         tirePressure: userUnitPreferences.tirePressure.rawValue)
    }
    
    private func map(_ userAdaptionValues: UserAdaptionValuesModel?) -> DBUserAdaptionValuesModel? {
        
        guard let userAdaptionValues = userAdaptionValues else {
            return nil
        }
        
        return DBUserAdaptionValuesModel(bodyHeight: userAdaptionValues.bodyHeight,
                                         preAdjustment: userAdaptionValues.preAdjustment,
                                         alias: userAdaptionValues.alias)
    }
    
    // MARK: DbModel -> Model
    private func map(_ dbUserAddressModel: DBUserAddressModel?) -> UserAddressModel {
        
        return UserAddressModel(
            city: dbUserAddressModel?.city,
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
    
    private func map(_ dbUserCommunicationPreferenceModel: DBUserCommunicationPreferenceModel?) -> UserCommunicationPreferenceModel {
        
        return UserCommunicationPreferenceModel(
            phone: dbUserCommunicationPreferenceModel?.phone.value,
            letter: dbUserCommunicationPreferenceModel?.letter.value,
            email: dbUserCommunicationPreferenceModel?.mail.value,
            sms: dbUserCommunicationPreferenceModel?.sms.value)
    }
    
    private func map(_ dbUserUnitPreferenceModel: DBUserUnitPreferenceModel?) -> UserUnitPreferenceModel {
        
        guard let dbUserUnitPreferenceModel = dbUserUnitPreferenceModel else {
            return UserUnitPreferenceModel()
        }
        
        return UserUnitPreferenceModel(
            clockHours: ClockHoursUnit(rawValue: dbUserUnitPreferenceModel.clockHours) ?? ClockHoursUnit.defaultCase,
            consumptionCo: ConsumptionCoUnit(rawValue: dbUserUnitPreferenceModel.consumptionCo) ?? ConsumptionCoUnit.defaultCase,
            consumptionEv: ConsumptionEvUnit(rawValue: dbUserUnitPreferenceModel.consumptionEv) ?? ConsumptionEvUnit.defaultCase,
            consumptionGas: ConsumptionGasUnit(rawValue: dbUserUnitPreferenceModel.consumptionGas) ?? ConsumptionGasUnit.defaultCase,
            speedDistance: SpeedDistanceUnit(rawValue: dbUserUnitPreferenceModel.speedDistance) ?? SpeedDistanceUnit.defaultCase,
            temperature: UserTemperatureUnit(rawValue: dbUserUnitPreferenceModel.temperature) ?? UserTemperatureUnit.defaultCase,
            tirePressure: TirePressureUnit(rawValue: dbUserUnitPreferenceModel.tirePressure) ?? TirePressureUnit.defaultCase)
    }
    
    private func map(_ dbAdaptionValues: DBUserAdaptionValuesModel?) -> UserAdaptionValuesModel? {
        
        guard let dbAdaptionValues = dbAdaptionValues else {
            return nil
        }
        
        return UserAdaptionValuesModel(bodyHeight: dbAdaptionValues.bodyHeight.value,
                                       preAdjustment: dbAdaptionValues.preAdjustment.value,
                                       alias: dbAdaptionValues.alias)
    }
}
