//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of gps related attributes
public struct VehicleLocationModel {
	
	public let heading: StatusAttributeType<Double, NoUnit>
	public let latitude: StatusAttributeType<Double, NoUnit>
	public let longitude: StatusAttributeType<Double, NoUnit>
    public let positionErrorCode: StatusAttributeType<PositionErrorState, NoUnit>
    public let proximityCalculationForVehiclePositionRequired: StatusAttributeType<Bool, NoUnit>
}
