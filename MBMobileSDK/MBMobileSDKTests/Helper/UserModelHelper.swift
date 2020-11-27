//
//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

import MBMobileSDK

class UserModelHelper {
    
    static func build(preferredLanguageCode: String = "de", accountCountryCode: String = "DE") -> UserModel {
        return UserModel(address: UserAddressModel(
                             city: "city",
                             countryCode: "countryCode",
                             houseNo: "houseNo",
                             state: "state",
                             street: "street",
                             zipCode: "zipCode",
                             province: "province",
                             doorNo: "doorNo",
                             addressLine1: "addressLine1",
                             streetType: "streetType",
                             houseName: "houseName",
                             floorNo: "floorNo",
                             addressLine2: "addressLine2",
                             addressLine3: "addressLine3",
                             postOfficeBox: "postOfficeBox"),
                         birthday: Date(),
                         ciamId: "ciamId",
                         createdAt: "createdAt",
                         email: "email",
                         firstName: "firstName",
                         lastName1: "lastName1",
                         lastName2: "lastName2",
                         landlinePhone: "landlinePhone",
                         mobilePhoneNumber: "mobilePhoneNumber",
                         updatedAt: "updatedAt",
                         accountCountryCode: accountCountryCode,
                         userPinStatus: UserPinStatus.set,
                         communicationPreference: UserCommunicationPreferenceModel(
                            phone: true,
                            letter: true,
                            email: true,
                            sms: true),
                         profileImageData: nil,
                         profileImageEtag: nil,
                         unitPreferences: UserUnitPreferenceModel(),
                         salutation: "salutation",
                         title: "title",
                         taxNumber: "taxNumber",
                         namePrefix: "namePrefix",
                         preferredLanguageCode: preferredLanguageCode,
                         middleInitial: "middleInitial",
                         accountIdentifier: "accountIdentifier",
                         adaptionValues: UserAdaptionValuesModel(
                            bodyHeight: 123,
                            preAdjustment: true,
                            alias: "alias"),
                         accountVerified: true,
                         isEmailVerified: true,
                         isMobileVerified: true)
    }
    
}
