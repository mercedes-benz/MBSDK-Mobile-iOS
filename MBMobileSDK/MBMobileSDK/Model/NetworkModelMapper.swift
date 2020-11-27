//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

// swiftlint:disable type_body_length

import Foundation
import MBCommonKit

class NetworkModelMapper {
	
	// MARK: - BusinessModel
	
	static func map(apiServiceGroupModels: [APIVehicleServiceGroupModel], finOrVin: String) -> [VehicleServiceGroupModel] {
		return apiServiceGroupModels.map { self.map(apiServiceGroupModel: $0, finOrVin: finOrVin) }
	}
	
	static func map(apiServiceGroupModel: APIVehicleServiceGroupModel, finOrVin: String) -> VehicleServiceGroupModel {
		return VehicleServiceGroupModel(group: apiServiceGroupModel.group,
										services: self.map(apiServiceModels: apiServiceGroupModel.services,
														   finOrVin: finOrVin))
	}
	
	static func map(apiServiceModels: [APIVehicleServiceModel], finOrVin: String) -> [VehicleServiceModel] {
		return apiServiceModels.map { self.map(apiServiceModel: $0, finOrVin: finOrVin) }
	}
	
	static func map(apiServiceModel: APIVehicleServiceModel, finOrVin: String) -> VehicleServiceModel {
		return VehicleServiceModel(activationStatus: apiServiceModel.activationStatus,
								   allowedActions: apiServiceModel.allowedActions.compactMap { ServiceAction(rawValue: $0) },
								   description: apiServiceModel.shortDescription ?? "",
								   finOrVin: finOrVin,
								   id: apiServiceModel.id,
								   missingData: self.map(apiServiceMissingDataModel: apiServiceModel.missingData),
								   name: apiServiceModel.name,
								   prerequisites: self.map(apiServicePrerequisiteModels: apiServiceModel.prerequisiteChecks ?? []),
								   shortName: apiServiceModel.shortName,
								   rights: apiServiceModel.rights)
	}
	
	private static func map(apiServiceMissingDataModel: APIVehicleServiceMissingDataModel?) -> VehicleServiceMissingDataModel? {
		
		guard let apiServiceMissingDataModel = apiServiceMissingDataModel,
			let missingAccountLinkage = self.map(apiServiceAccountLinkageModel: apiServiceMissingDataModel.missingAccountLinkage) else {
				return nil
		}
		return VehicleServiceMissingDataModel(missingAccountLinkage: missingAccountLinkage)
	}
	
	private static func map(apiServiceAccountLinkageModel: APIVehicleServiceAccountLinkageModel?) -> VehicleServiceAccountLinkageModel? {
		
		guard let apiServiceAccountLinkageModel = apiServiceAccountLinkageModel,
			let accountType = AccountType(rawValue: apiServiceAccountLinkageModel.accountType) else {
				return nil
		}
		return VehicleServiceAccountLinkageModel(accountType: accountType,
												 mandatory: apiServiceAccountLinkageModel.mandatory)
	}
	
	static func map(apiServicePrerequisiteModels: [APIVehicleServicePrerequisiteModel]) -> [VehicleServicePrerequisiteModel] {
		return apiServicePrerequisiteModels.map { self.map(apiServicePrerequisiteModel: $0) }
	}
	
	static func map(apiServicePrerequisiteModel: APIVehicleServicePrerequisiteModel) -> VehicleServicePrerequisiteModel {
		return VehicleServicePrerequisiteModel(actions: apiServicePrerequisiteModel.actions.compactMap { ServiceAction(rawValue: $0) },
											   missingFields: apiServicePrerequisiteModel.missingFields ?? [],
											   name: apiServicePrerequisiteModel.name)
	}
	
	static func map(apiVehicleDataModels: [APIVehicleDataModel]) -> [VehicleModel] {
		return apiVehicleDataModels.map { self.map(apiVehicleDataModel: $0) }
	}
	
	static func map(apiVehicleDataModel: APIVehicleDataModel) -> VehicleModel {
		
		let model: String = apiVehicleDataModel.salesRelatedInformation?.baumuster?.baumusterDescription ?? ""
		return VehicleModel(baumuster: apiVehicleDataModel.salesRelatedInformation?.baumuster?.baumuster ?? "",
							carline: apiVehicleDataModel.carline,
							dataCollectorVersion: apiVehicleDataModel.dataCollectorVersion,
							dealers: self.map(apiVehicleDealerItemsModel: apiVehicleDataModel.dealers),
							doorsCount: apiVehicleDataModel.doorsCount,
							fin: apiVehicleDataModel.fin ?? "",
							fuelType: apiVehicleDataModel.fuelType,
							handDrive: apiVehicleDataModel.handDrive,
							hasAuxHeat: apiVehicleDataModel.hasAuxHeat ?? false,
							hasFacelift: apiVehicleDataModel.mopf ?? false,
							indicatorImageUrl: URL(string: apiVehicleDataModel.indicatorImageUrl ?? ""),
							isOwner: apiVehicleDataModel.isOwner,
							licensePlate: apiVehicleDataModel.licensePlate ?? "",
							model: model.isEmpty == false ? model : apiVehicleDataModel.technicalInformation?.salesDesignation ?? "",
							normalizedProfileControlSupport: apiVehicleDataModel.normalizedProfileControlSupport,
                            pending: nil,
                            profileSyncSupport: apiVehicleDataModel.profileSyncSupport,
							roofType: apiVehicleDataModel.roofType,
							starArchitecture: StarArchitecture(rawValue: apiVehicleDataModel.starArchitecture ?? "") ?? .unknown,
							tcuHardwareVersion: TcuHardwareVersion(rawValue: apiVehicleDataModel.tcuHardwareVersion ?? "") ?? .unknown,
							tcuSoftwareVersion: TcuSoftwareVersion(rawValue: apiVehicleDataModel.tcuSoftwareVersion ?? "") ?? .unknown,
							tirePressureMonitoringType: apiVehicleDataModel.tirePressureMonitoringType,
							trustLevel: apiVehicleDataModel.trustLevel ?? 0,
							vin: apiVehicleDataModel.vin ?? "",
							windowsLiftCount: apiVehicleDataModel.windowsLiftCount,
							vehicleConnectivity: apiVehicleDataModel.vehicleConnectivity,
							vehicleSegment: apiVehicleDataModel.vehicleSegment ?? .default,
							paint: self.map(apiVehicleDataModel.salesRelatedInformation?.paint1),
							upholstery: self.map(apiVehicleDataModel.salesRelatedInformation?.upholstery),
							line: self.map(apiVehicleDataModel.salesRelatedInformation?.line))
	}
	
    static func map(_ apiVehicleAmenityModel: APIVehicleAmenityModel?) -> VehicleAmenityModel? {
        guard let apiVehicleAmenityModel = apiVehicleAmenityModel else {
            return nil
        }
        return VehicleAmenityModel(code: apiVehicleAmenityModel.code, description: apiVehicleAmenityModel.description)
    }
    
	static func map(apiVehicleImagesModel: [APIVehicleImageModel]) -> [ImageModel] {
		return apiVehicleImagesModel.map { self.map(apiVehicleImageModel: $0) }
	}
	
	static func map(apiVehicleImageModel: APIVehicleImageModel) -> ImageModel {
		return ImageModel(errorDescription: apiVehicleImageModel.error?.message,
						  imageKey: apiVehicleImageModel.imageKey,
						  url: apiVehicleImageModel.url)
	}
    
    static func map(apiVehicleTopViewImageModel model: APIVehicleTopViewImageModel) -> TopImageModel {
        return TopImageModel(
            vin: model.vin,
            components: model.components.map { NetworkModelMapper.map(apiVehicleTopViewImageComponentModel: $0) })
    }
    
    static func map(apiVehicleTopViewImageComponentModel model: APIVehicleTopViewImageComponentModel) -> TopImageComponentModel {
        return TopImageComponentModel(name: model.name, imageData: model.imageData)
    }
	
	static func map(apiVehicleRifModel: APIVehicleRifModel, finOrVin: String) -> VehicleSupportableModel {
		return VehicleSupportableModel(canReceiveVACs: apiVehicleRifModel.canCarReceiveVACs,
									   finOrVin: finOrVin,
                                       vehicleConnectivity: apiVehicleRifModel.vehicleConnectivity ?? .none)
	}
	
	static func map(apiVehicleVinImagesModel: [APIVehicleVinImageModel]) -> [VehicleImageModel] {
		return apiVehicleVinImagesModel.map { self.map(apiVehicleVinImageModel: $0) }
	}
	
	static func map(apiVehicleVinImageModel: APIVehicleVinImageModel) -> VehicleImageModel {
		return VehicleImageModel(images: self.map(apiVehicleImagesModel: apiVehicleVinImageModel.images),
								 vin: apiVehicleVinImageModel.vinOrFin)
	}
	
	// MARK: - NetworkModel
	
	static func map(serviceModels: [VehicleServiceModel]) -> [APIVehicleServiceActivationModel] {
		return serviceModels.map { self.map(serviceModel: $0) }
	}
	
	static func map(serviceModel: VehicleServiceModel) -> APIVehicleServiceActivationModel {
		return APIVehicleServiceActivationModel(desiredServiceStatus: serviceModel.activationStatus.toogled,
												serviceId: serviceModel.serviceId)
	}
    
    // MARK: - BusinessModel
    
    static func map(apiAgreementDocModels: [APIAgreementDocModel]) -> [AgreementDocModel] {
        return apiAgreementDocModels.map { self.map(apiAgreementDocModel: $0) }
    }
    
    static func map(apiAgreementDocModel: APIAgreementDocModel) -> AgreementDocModel {
        return AgreementDocModel(acceptedByUser: apiAgreementDocModel.acceptedByUser,
                                 acceptedLocale: apiAgreementDocModel.acceptedLocale ?? "",
                                 documentId: apiAgreementDocModel.documentId,
                                 version: apiAgreementDocModel.version)
    }
    
    static func map(apiAgreementsModel: APIAgreementsModel) -> AgreementsModel {
        return AgreementsModel(ciam: apiAgreementsModel.ciam?.map { self.map(apiCiamAgreementModel: $0) } ?? [],
                               custom: apiAgreementsModel.custom?.map { self.map(apiCustomAgreementModel: $0) } ?? [],
                               soe: apiAgreementsModel.soe?.map { self.map(apiSoeAgreementModel: $0) } ?? [],
                               ldsso: apiAgreementsModel.ldsso?.map { self.map(apiLdssoAgreementModel: $0) } ?? [],
                               toas: self.map(apiToasAgreementModel: apiAgreementsModel.toas),
                               natCon: self.map(apiNatConAgreementModel: apiAgreementsModel.natCon))
    }
    
    static func map(apiSoeAgreementModel: APISoeAgreementModel) -> SoeAgreementModel {
        return SoeAgreementModel(href: apiSoeAgreementModel.href,
                                 documentID: apiSoeAgreementModel.documentID,
                                 version: apiSoeAgreementModel.version,
                                 position: apiSoeAgreementModel.position,
                                 displayName: apiSoeAgreementModel.displayName,
                                 acceptanceState: self.map(apiAgreementAcceptanceState: apiSoeAgreementModel.acceptanceState),
                                 checkBoxTextKey: apiSoeAgreementModel.checkBoxTextKey,
                                 isGeneralUserAgreement: apiSoeAgreementModel.isGeneralUserAgreement,
                                 checkBoxText: apiSoeAgreementModel.checkBoxText,
                                 titleText: apiSoeAgreementModel.titleText)
    }
    
    static func map(apiCiamAgreementModel: APICiamAgreementModel) -> CiamAgreementModel {
        return CiamAgreementModel(acceptanceState: self.map(apiAgreementAcceptanceState: apiCiamAgreementModel.acceptanceState),
                                  href: apiCiamAgreementModel.href,
                                  documentID: apiCiamAgreementModel.documentID,
                                  version: apiCiamAgreementModel.version)
    }
    
    static func map(apiLdssoAgreementModel: APILdssoAgreementModel) -> LdssoAgreementModel {
        return LdssoAgreementModel(documentID: apiLdssoAgreementModel.documentID,
                                   locale: apiLdssoAgreementModel.locale,
                                   version: apiLdssoAgreementModel.version,
                                   position: apiLdssoAgreementModel.position,
                                   displayName: apiLdssoAgreementModel.displayName,
                                   implicitConsent: apiLdssoAgreementModel.implicitConsent,
                                   href: apiLdssoAgreementModel.href,
                                   acceptanceState: self.map(apiAgreementAcceptanceState: apiLdssoAgreementModel.acceptanceState))
    }
    
    static func map(apiNatConAgreementModel: APINatConAgreementModel?) -> NatConAgreementModel? {
        guard let apiModel = apiNatConAgreementModel else {
            return nil
        }
        
        return NatConAgreementModel(acceptAllText: apiModel.acceptAllText,
									title: apiModel.title,
									description: apiModel.description,
									version: apiModel.version,
									documents: apiModel.documents.compactMap {
                                        self.map(apiNatConAgreementDocumentModel: $0)
									})
    }
    
    static func map(apiNatConAgreementDocumentModel: APINatConAgreementDocumentModel) -> NatConAgreementDocumentModel {
        
        return NatConAgreementDocumentModel(isMandatory: apiNatConAgreementDocumentModel.isMandatory,
                                            position: apiNatConAgreementDocumentModel.position,
                                            termsId: apiNatConAgreementDocumentModel.termsId,
                                            text: apiNatConAgreementDocumentModel.text,
                                            href: apiNatConAgreementDocumentModel.href,
                                            language: apiNatConAgreementDocumentModel.language,
                                            acceptanceState: self.map(apiAgreementAcceptanceState: apiNatConAgreementDocumentModel.acceptanceState ?? .unseen))
    }
    
    static func map(apiToasAgreementModel: APIToasAgreementModel?) -> ToasAgreementModel? {
        return ToasAgreementModel(documents: self.map(apiToasDocumentModels: apiToasAgreementModel?.documents ?? []),
                                  checkboxes: self.map(apiToasCheckboxModels: apiToasAgreementModel?.checkboxes ?? []))
    }
    
    static func map(apiCustomAgreementModel: APICustomAgreementModel) -> CustomAgreementModel {
        return CustomAgreementModel(acceptanceState: self.map(apiAgreementAcceptanceState: apiCustomAgreementModel.acceptanceState),
                                    displayLocation: apiCustomAgreementModel.displayLocation,
                                    displayName: apiCustomAgreementModel.displayName,
                                    position: apiCustomAgreementModel.position,
                                    documentID: apiCustomAgreementModel.documentID,
                                    href: apiCustomAgreementModel.href,
                                    version: apiCustomAgreementModel.version)
    }
    
    static func map(apiAgreementConfirmModel: APIAgreementConfirmModel) -> AgreementConfirmModel {
        return AgreementConfirmModel(agreementConsents: apiAgreementConfirmModel.allUserAgreementConsentsSet ?? false,
                                     unsuccessfulIds: apiAgreementConfirmModel.unsuccessfulSetDocIds)
    }
    
    static func map(apiAgreementModels: [APIAgreementModel]) -> [AgreementModel] {
        return apiAgreementModels.map { self.map(apiAgreementModel: $0) }
    }
    
    static func map(apiToasDocumentModels: [APIToasDocumentModel]) -> [ToasDocumentModel] {
        return apiToasDocumentModels.map { ToasDocumentModel(acceptanceState: self.map(apiAgreementAcceptanceState: $0.acceptanceState),
                                                             displayName: $0.displayName,
                                                             documentID: $0.documentID,
                                                             href: $0.href,
                                                             version: $0.version) }
    }
    
    static func map(apiAgreementAcceptanceState: APIAgreementAcceptanceState) -> AgreementAcceptanceState {
        switch apiAgreementAcceptanceState {
        case .accepted: return AgreementAcceptanceState.accepted
        case .rejected: return AgreementAcceptanceState.rejected
        case .unseen:   return AgreementAcceptanceState.unseen
        }
    }
        
    static func map(apiToasCheckboxModels: [APIToasCheckboxModel]) -> [ToasCheckboxModel] {
        return apiToasCheckboxModels.map { ToasCheckboxModel(caption: $0.caption,
                                                             texts: self.map(apiToasDocumentModels: $0.texts ))}
    }
    
    static func map(apiAgreementModel: APIAgreementModel) -> AgreementModel {
        
        let documentData = Data(base64Encoded: apiAgreementModel.documentData)
        return AgreementModel(documentData: documentData,
                              documents: self.map(apiAgreementDocModels: apiAgreementModel.documents))
    }
    
    static func map(apiCountries: [APICountryModel]) -> [CountryModel] {
        return apiCountries.map { self.map(apiCountry: $0) }
    }
    
    static func map(apiCountry: APICountryModel) -> CountryModel {
        return CountryModel(availability: apiCountry.availability,
                            countryCode: apiCountry.countryCode,
                            countryName: apiCountry.countryName,
                            instance: apiCountry.instance,
                            legalRegion: apiCountry.legalRegion,
                            locales: self.map(apiCountryLocales: apiCountry.locales ?? [] ),
                            natconCountry: apiCountry.natconCountry)
    }
    
    static func map(apiCountryLocales: [APICountryLocaleModel]) -> [CountryLocaleModel] {
        return apiCountryLocales.map { self.map(apiCountryLocale: $0) }
    }
    
    static func map(apiCountryLocale: APICountryLocaleModel) -> CountryLocaleModel {
        return CountryLocaleModel(localeCode: apiCountryLocale.localeCode,
                                  localeName: apiCountryLocale.localeName)
    }
    
    static func map(apiLogin: APILoginModel, authenticationType: AuthenticationType) -> Token {
        return TokenMapper().map(from: apiLogin, authenticationType: authenticationType)
    }
    
    static func map(apiRegistrationUser: APIRegistrationUserModel) -> RegistrationUserModel {
        return RegistrationUserModel(countryCode: apiRegistrationUser.countryCode,
                                     email: apiRegistrationUser.email,
                                     firstName: apiRegistrationUser.firstName,
                                     lastName: apiRegistrationUser.lastName,
                                     mobileNumber: apiRegistrationUser.mobileNumber,
                                     useEmailAsUsername: apiRegistrationUser.useEmailAsUsername,
                                     userName: apiRegistrationUser.username)
    }
    
    static func map(apiUserExist: APIUserExistModel) -> UserExistModel {
        return UserExistModel(isEmail: apiUserExist.isEmail,
                              username: apiUserExist.username)
    }
    
    static func map(apiUser: APIUserModel) -> UserModel {
        return UserModel(address: self.map(apiUserAddress: apiUser.address),
                         birthday: DateFormattingHelper.date(apiUser.birthday, format: DateFormat.birthday),
                         ciamId: apiUser.ciamId,
                         createdAt: apiUser.createdAt,
                         email: apiUser.email,
                         firstName: apiUser.firstName ?? "",
                         lastName1: apiUser.lastName1 ?? "",
                         lastName2: apiUser.lastName2 ?? "",
                         landlinePhone: apiUser.landlinePhone,
                         mobilePhoneNumber: apiUser.mobilePhoneNumber,
                         updatedAt: apiUser.updatedAt,
                         accountCountryCode: apiUser.accountCountryCode ?? "",
                         userPinStatus: UserPinStatus(rawValue: apiUser.userPinStatus ?? UserPinStatus.unknown.rawValue) ?? .unknown,
                         communicationPreference: self.map(preference: apiUser.communicationPreference),
                         profileImageData: nil,
                         profileImageEtag: nil,
                         unitPreferences: self.map(preference: apiUser.unitPreferences),
                         salutation: apiUser.salutationCode,
                         title: apiUser.title,
                         taxNumber: apiUser.taxNumber,
                         namePrefix: apiUser.namePrefix,
                         preferredLanguageCode: apiUser.preferredLanguageCode ?? "",
                         middleInitial: apiUser.middleInitial,
                         accountIdentifier: apiUser.accountIdentifier,
                         adaptionValues: self.map(apiAdaptionValues: apiUser.adaptionValues),
                         accountVerified: apiUser.accountVerified,
                         isEmailVerified: apiUser.isEmailVerified ?? false,
                         isMobileVerified: apiUser.isMobileVerified ?? false)
    }
    
    private static func map(apiUserAddress: APIUserAddressModel?) -> UserAddressModel {
        return UserAddressModel(city: apiUserAddress?.city,
                                countryCode: apiUserAddress?.countryCode,
                                houseNo: apiUserAddress?.houseNo,
                                state: apiUserAddress?.state,
                                street: apiUserAddress?.street,
                                zipCode: apiUserAddress?.zipCode,
                                province: apiUserAddress?.province,
                                doorNo: apiUserAddress?.doorNo,
                                addressLine1: apiUserAddress?.addressLine1,
                                streetType: apiUserAddress?.streetType,
                                houseName: apiUserAddress?.houseName,
                                floorNo: apiUserAddress?.floorNo,
                                addressLine2: apiUserAddress?.addressLine2,
                                addressLine3: apiUserAddress?.addressLine3,
                                postOfficeBox: apiUserAddress?.postOfficeBox)
    }
    
    private static func map(preference: APIUserCommunicationPreferenceModel?) -> UserCommunicationPreferenceModel {
        return UserCommunicationPreferenceModel(phone: preference?.contactedByPhone,
                                            letter: preference?.contactedByLetter,
                                            email: preference?.contactedByEmail,
                                            sms: preference?.contactedBySms)
    }
    
    private static func map(preference: APIUserUnitPreferenceModel) -> UserUnitPreferenceModel {
        return UserUnitPreferenceModel(clockHours: preference.clockHours,
                                       consumptionCo: preference.consumptionCo,
                                       consumptionEv: preference.consumptionEv,
                                       consumptionGas: preference.consumptionGas,
                                       speedDistance: preference.speedDistance,
                                       temperature: preference.temperature,
                                       tirePressure: preference.tirePressure)
    }
    
    private static func map(apiAdaptionValues: APIUserAdaptionValuesModel?) -> UserAdaptionValuesModel? {
        
        guard let apiAdaptionValues = apiAdaptionValues else {
            return nil
        }
        
        return UserAdaptionValuesModel(bodyHeight: apiAdaptionValues.bodyHeight, preAdjustment: apiAdaptionValues.preAdjustment, alias: apiAdaptionValues.alias)
    }
    
    
    // MARK: - APIModel
    
    private static func map(userAddress: UserAddressModel) -> APIUserAddressModel {
        return APIUserAddressModel(countryCode: userAddress.countryCode,
                                   state: userAddress.state,
                                   province: userAddress.province,
                                   street: userAddress.street,
                                   houseNo: userAddress.houseNo,
                                   zipCode: userAddress.zipCode,
                                   city: userAddress.city,
                                   streetType: userAddress.streetType,
                                   houseName: userAddress.houseName,
                                   floorNo: userAddress.floorNo,
                                   doorNo: userAddress.doorNo,
                                   addressLine1: userAddress.addressLine1,
                                   addressLine2: userAddress.addressLine2,
                                   addressLine3: userAddress.addressLine3,
                                   postOfficeBox: userAddress.postOfficeBox)
    }
    
    static func map(user: UserModel, nonce: String?) -> APIUserModel {
        let communicationPreference = APIUserCommunicationPreferenceModel(contactedByPhone: user.communicationPreference.phone,
                                                                          contactedByLetter: user.communicationPreference.letter,
                                                                          contactedByEmail: user.communicationPreference.email,
                                                                          contactedBySms: user.communicationPreference.sms)
        return APIUserModel(ciamId: user.ciamId,
                            firstName: user.firstName,
                            lastName1: user.lastName1,
                            lastName2: user.lastName2,
                            title: user.title,
                            namePrefix: user.namePrefix,
                            middleInitial: user.middleInitial,
                            salutationCode: user.salutation,
                            email: user.email,
                            landlinePhone: user.landlinePhone,
                            mobilePhoneNumber: user.mobilePhoneNumber,
                            birthday: DateFormattingHelper.string(user.birthday, format: DateFormat.birthday),
                            preferredLanguageCode: user.preferredLanguageCode,
                            accountCountryCode: user.accountCountryCode,
                            createdAt: user.createdAt,
                            createdBy: nil,
                            updatedAt: user.updatedAt,
                            address: self.map(userAddress: user.address),
                            communicationPreference: communicationPreference,
                            userPinStatus: user.userPinStatus.rawValue,
                            unitPreferences: self.map(preference: user.unitPreferences),
                            taxNumber: user.taxNumber,
                            accountIdentifier: user.accountIdentifier,
                            useEmailAsUsername: user.accountIdentifier == "email",
                            adaptionValues: self.map(adaptionValues: user.adaptionValues),
                            accountVerified: user.accountVerified,
                            isEmailVerified: user.isEmailVerified,
                            isMobileVerified: user.isMobileVerified,
                            toasConsents: user.toasConsents,
                            nonce: nonce)
    }
    
    static func map(preference: UserCommunicationPreferenceModel) -> APIUserCommunicationPreferenceModel {
        return APIUserCommunicationPreferenceModel(contactedByPhone: preference.phone,
                                                   contactedByLetter: preference.letter,
                                                   contactedByEmail: preference.email,
                                                   contactedBySms: preference.sms)
    }
    
    static func map(preference: UserUnitPreferenceModel) -> APIUserUnitPreferenceModel {
        return APIUserUnitPreferenceModel(clockHours: preference.clockHours,
                                          consumptionCo: preference.consumptionCo,
                                          consumptionEv: preference.consumptionEv,
                                          consumptionGas: preference.consumptionGas,
                                          speedDistance: preference.speedDistance,
                                          temperature: preference.temperature,
                                          tirePressure: preference.tirePressure)
    }
    
    static func map(adaptionValues: UserAdaptionValuesModel?) -> APIUserAdaptionValuesModel? {
        return APIUserAdaptionValuesModel(bodyHeight: adaptionValues?.bodyHeight,
                                          preAdjustment: adaptionValues?.preAdjustment,
                                          alias: adaptionValues?.alias)
    }
}
