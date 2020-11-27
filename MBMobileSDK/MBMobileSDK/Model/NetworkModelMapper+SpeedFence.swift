//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//


import Foundation

extension NetworkModelMapper {
    
	// MARK: - API to business
	
    static func map(apiSpeedfenceModels: [APISpeedFenceModel]) -> [SpeedFenceModel] {
        return apiSpeedfenceModels.map { self.map(apiSpeedfenceModel: $0) }
    }
    
	static func map(apiSpeedfenceViolationModels: [APISpeedFenceViolationModel]) -> [SpeedFenceViolationModel] {
		return apiSpeedfenceViolationModels.map { self.map(apiSpeedfenceViolationModel: $0) }
	}
	
	
	// MARK: - Business to API
	
	static func map(speedfenceRequestModels: [SpeedFenceRequestModel]) -> [APISpeedFenceRequestModel] {
        return speedfenceRequestModels.map { self.map(speedfenceRequestModel: $0) }
    }
	
	
	// MARK: - Helper
	
    private static func map(apiSpeedfenceModel: APISpeedFenceModel) -> SpeedFenceModel {
        return SpeedFenceModel(geofenceId: apiSpeedfenceModel.geofenceid,
                          name: apiSpeedfenceModel.name,
                          isActive: apiSpeedfenceModel.isActive,
                          endTime: apiSpeedfenceModel.endtime,
                          threshold: apiSpeedfenceModel.threshold,
                          violationDelay: apiSpeedfenceModel.violationdelay,
                          violationTypes: apiSpeedfenceModel.violationtype,
                          timestamp: apiSpeedfenceModel.ts,
                          speedfenceId: apiSpeedfenceModel.speedfenceid,
                          syncStatus: apiSpeedfenceModel.syncstatus)
    }
	
    private static func map(apiSpeedfenceViolationModel: APISpeedFenceViolationModel) -> SpeedFenceViolationModel {
		
		let coordinate: CoordinateModel? = {
			guard let latitude = apiSpeedfenceViolationModel.coordinates?.latitude,
				let longitude = apiSpeedfenceViolationModel.coordinates?.longitude else {
					return nil
			}
			return CoordinateModel(latitude: latitude,
								   longitude: longitude)
		}()
        
        let speedfence: SpeedFenceModel? = {
            guard let apiSpeedfence = apiSpeedfenceViolationModel.speedfence else {
                return nil
            }
            return self.map(apiSpeedFenceModel: apiSpeedfence)
        }()
        
        let onboardfence: OnboardFenceModel? = {
            guard let apiOnboardfence = apiSpeedfenceViolationModel.onboardfence else {
                return nil
            }
            return self.map(apiOnboardFenceModel: apiOnboardfence)
        }()
        
		return SpeedFenceViolationModel(coordinate: coordinate,
                                        speedfence: speedfence,
                                        onboardfence: onboardfence,
										time: apiSpeedfenceViolationModel.time,
										violationId: apiSpeedfenceViolationModel.violationid)
	}
    
    private static func map(apiSpeedFenceModel: APISpeedFenceModel) -> SpeedFenceModel {
        return SpeedFenceModel(geofenceId: apiSpeedFenceModel.geofenceid,
                          name: apiSpeedFenceModel.name,
                          isActive: apiSpeedFenceModel.isActive,
                          endTime: apiSpeedFenceModel.endtime,
                          threshold: apiSpeedFenceModel.threshold,
                          violationDelay: apiSpeedFenceModel.violationdelay,
                          violationTypes: apiSpeedFenceModel.violationtype,
                          timestamp: apiSpeedFenceModel.ts,
                          speedfenceId: apiSpeedFenceModel.speedfenceid,
                          syncStatus: apiSpeedFenceModel.syncstatus)
    }
	
	private static func map(speedfenceRequestModel: SpeedFenceRequestModel) -> APISpeedFenceRequestModel {
        return APISpeedFenceRequestModel(speedfenceid: speedfenceRequestModel.speedfenceId,
                                         geofenceid: speedfenceRequestModel.geofenceId,
                                         name: speedfenceRequestModel.name,
                                         isActive: speedfenceRequestModel.isActive,
                                         endtime: speedfenceRequestModel.endTime,
                                         threshold: speedfenceRequestModel.threshold,
                                         unit: speedfenceRequestModel.unit?.queryString,
                                         violationdelay: speedfenceRequestModel.violationDelay,
                                         violationtype: speedfenceRequestModel.violationType)
    }
}
