//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of user address
public struct UserAddressModel: Equatable {

	public let city: String?
	public let countryCode: String?
	public let houseNo: String?
	public let state: String?
	public let street: String?
	public let zipCode: String?
    public let province: String?
    public let doorNo: String?
    public let addressLine1: String?
    public let streetType: String?
    public let houseName: String?
    public let floorNo: String?
    public let addressLine2: String?
    public let addressLine3: String?
    public let postOfficeBox: String?

    // MARK: - Public Init
    
    public init(city: String?,
                countryCode: String?,
                houseNo: String?,
                state: String?,
                street: String?,
                zipCode: String?,
                province: String?,
                doorNo: String?,
                addressLine1: String?,
                streetType: String?,
                houseName: String?,
                floorNo: String?,
                addressLine2: String?,
                addressLine3: String?,
                postOfficeBox: String?) {
        
        self.city = city
        self.countryCode = countryCode
        self.houseNo = houseNo
        self.state = state
        self.street = street
        self.zipCode = zipCode
        self.province = province
        self.doorNo = doorNo
        self.addressLine1 = addressLine1
        self.streetType = streetType
        self.houseName = houseName
        self.floorNo = floorNo
        self.addressLine2 = addressLine2
        self.addressLine3 = addressLine3
        self.postOfficeBox = postOfficeBox
    }
}
