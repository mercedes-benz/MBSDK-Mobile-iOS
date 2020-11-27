//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - Assignment

extension NetworkModelMapper {
	
	// MARK: - BusinessModel
	
	static func map(apiAssignmentModel: APIAssignmentModel) -> AssignmentModel {
		return AssignmentModel(assignmentType: AssignmentUserType(rawValue: apiAssignmentModel.assignmentType ?? "") ?? .unknown,
							   vin: apiAssignmentModel.vin)
	}
	
	static func map(apiAssignmentPreconditionModel: APIAssignmentPreconditionModel) -> AssignmentPreconditionModel {
		return AssignmentPreconditionModel(assignmentType: AssignmentUserType(rawValue: apiAssignmentPreconditionModel.assignmentType ?? "") ?? .unknown,
										   mercedesMePinRequired: apiAssignmentPreconditionModel.mercedesMePinRequired ?? false,
                                           model: self.modelName(for: apiAssignmentPreconditionModel),
										   termsOfUseRequired: apiAssignmentPreconditionModel.termsOfUseRequired ?? false,
										   vin: apiAssignmentPreconditionModel.vin)
	}
    
    private static func modelName(for assignmentModel: APIAssignmentPreconditionModel) -> String {
        // baumusterDescription and salesDesignation can both be empty strings on top of being optionals
        
        if let baumuster = assignmentModel.baumusterDescription, baumuster.isEmpty == false {
            return baumuster
        } else if let salesDesignation = assignmentModel.salesDesignation, salesDesignation.isEmpty == false {
            return salesDesignation
        } else {
            return ""
        }
    }
}
