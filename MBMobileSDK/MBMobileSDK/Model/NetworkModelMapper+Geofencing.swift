//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

extension NetworkModelMapper {

    static func map(apiGeofenceModels: [APIGeofence]) -> [GeofenceModel] {
        return apiGeofenceModels.map { self.map(apiGeofenceModel: $0) }
    }

    static func map(apiGeofenceModel apiModel: APIGeofence) -> GeofenceModel {

		let activeTimes = ActiveTimesModel(begin: apiModel.activeTimes.begin,
										   end: apiModel.activeTimes.end,
										   days: self.map(activeDays: apiModel.activeTimes.days))
		
        return GeofenceModel(id: apiModel.id, isActive: apiModel.isActive,
                             name: apiModel.name,
                             activeTimes: activeTimes,
                             violationType: self.map(violationType: apiModel.violationType),
                             shape: self.map(apiShapeModel: apiModel.shape))
    }

    static func map(apiViolationModels: [APIViolation]) -> [ViolationModel] {
        return apiViolationModels.map {
			
			let coordinate = CoordinateModel(latitude: $0.coordinate.latitude,
											 longitude: $0.coordinate.longitude)
			return ViolationModel(id: $0.id,
								  violationType: self.map(violationType: $0.violationType),
								  fenceId: $0.fenceID,
								  time: $0.time,
								  coordinate: coordinate,
								  geofence: self.map(apiGeofenceModel: $0.geofence))
        }
    }

    private static func map(apiShapeModel apiModel: APIShape) -> ShapeModel {

        if let center = apiModel.center {
            return ShapeModel(center: self.map(apiCoordinateModel: center), radius: apiModel.radius, coordinates: nil)
        }

        if let coordinates = apiModel.coordinates {
            
            let coordinatesModel = coordinates.map { self.map(apiCoordinateModel: $0) }
            return ShapeModel(coordinates: coordinatesModel)
        }
        return ShapeModel()
    }

    private static func map(apiCoordinateModel apiModel: APICoordinateModel) -> CoordinateModel {
        return CoordinateModel(latitude: apiModel.latitude, longitude: apiModel.longitude)
    }

    private static func map(activeDays: [Int]) -> [Day] {
        return activeDays.compactMap { Day.mapShifftedMinusOneDay($0) }
    }

    private static func map(violationType: String) -> ViolationType {
        return ViolationType(rawValue: violationType) ?? .enter
    }
}
