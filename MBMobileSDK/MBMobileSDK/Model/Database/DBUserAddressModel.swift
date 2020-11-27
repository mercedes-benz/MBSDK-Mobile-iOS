//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

/// Database class of user address object
@objcMembers class DBUserAddressModel: Object {
	
	dynamic var countryCode: String?
	dynamic var state: String?
	dynamic var province: String?
	dynamic var street: String?
	dynamic var houseNo: String?
	dynamic var zipCode: String?
	dynamic var city: String?
	dynamic var streetType: String?
	dynamic var houseName: String?
	dynamic var floorNo: String?
	dynamic var doorNo: String?
	dynamic var addressLine1: String?
	dynamic var addressLine2: String?
	dynamic var addressLine3: String?
	dynamic var postOfficeBox: String?
	
	let user = LinkingObjects(fromType: DBUserModel.self, property: "address")
    
	override required init() {
        super.init()
    }
    
    init(countryCode: String?,
         state: String?,
         province: String?,
         street: String?,
         houseNo: String?,
         zipCode: String?,
         city: String?,
         streetType: String?,
         houseName: String?,
         floorNo: String?,
         doorNo: String?,
         addressLine1: String?,
         addressLine2: String?,
         addressLine3: String?,
         postOfficeBox: String?) {
        
        self.countryCode = countryCode
        self.state = state
        self.province = province
        self.street = street
        self.houseNo = houseNo
        self.zipCode = zipCode
        self.city = city
        self.streetType = streetType
        self.houseName = houseName
        self.floorNo = floorNo
        self.doorNo = doorNo
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.addressLine3 = addressLine3
        self.postOfficeBox = postOfficeBox

        super.init()
    }
}
