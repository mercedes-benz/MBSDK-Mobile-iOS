//
//  Copyright © 2020 Daimler AG. All rights reserved.
//

import Foundation

extension NetworkModelMapper {

    static func map(apiAVPReservationStatus apiModel: APIAVPReservationStatusModel) -> AVPReservationStatusModel {
        return AVPReservationStatusModel(reservationId: apiModel.reservationId,
										 driveType: AutomaticValetParkingDriveType(rawValue: apiModel.driveType),
										 driveStatus: AutomatedValetParkingDriveStatus(rawValue: apiModel.driveStatus) ?? .unknown,
										 errorIds: apiModel.errorIds,
										 estimatedTimeOfArrival: DateFormattingHelper.date(apiModel.estimatedTimeOfArrival, format: DateFormat.iso8601),
										 parkedLocation: apiModel.parkedLocation)
        
    }
    
    static func map(apiAVPReservationStatus apiModels: [APIAVPReservationStatusModel]) -> [AVPReservationStatusModel]? {
        return apiModels.map { self.map(apiAVPReservationStatus: $0) }
    }
}
