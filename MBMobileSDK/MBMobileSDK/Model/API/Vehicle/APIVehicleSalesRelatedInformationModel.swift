//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIVehicleSalesRelatedInformationModel: Decodable {
	let baumuster: APIVehicleBaumusterModel?
    let paint1: APIVehicleAmenityModel?
    let upholstery: APIVehicleAmenityModel?
    let line: APIVehicleAmenityModel?
}
