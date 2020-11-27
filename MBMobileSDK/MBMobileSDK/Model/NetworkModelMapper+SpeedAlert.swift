//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

extension NetworkModelMapper {
    
    static func map(apiSpeedAlertViolationModels: [APISpeedAlertViolation]) -> [SpeedAlertViolationModel] {
        return apiSpeedAlertViolationModels.map { self.map(apiSppedAlertViolationModel: $0) }
    }
    
    static func map(apiSppedAlertViolationModel apiModel: APISpeedAlertViolation) -> SpeedAlertViolationModel {
        return SpeedAlertViolationModel(id: apiModel.id,
                                        time: apiModel.time,
                                        speedalertTreshold: apiModel.speedalertTreshold,
                                        speedalertEndtime: apiModel.time,
                                        coordinates: self.map(apiSpeedAlertCoordinate: apiModel.coordinates))
    }
    
    static func map(apiSpeedAlertCoordinate apiModel: APISpeedAlertCoordinates) -> SpeedAlertCoordinatesModel {
        return SpeedAlertCoordinatesModel(latitude: apiModel.latitude,
										  longitude: apiModel.longitude,
										  heading: apiModel.heading)
    }
}
