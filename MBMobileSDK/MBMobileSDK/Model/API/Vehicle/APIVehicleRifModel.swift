//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIVehicleRifModel: Decodable {
	let canCarReceiveVACs: Bool
	let isRifSupportedForVAC: Bool
	let isPushNotificationSupportedForVAC: Bool
	let vehicleConnectivity: VehicleConnectivity?
}
