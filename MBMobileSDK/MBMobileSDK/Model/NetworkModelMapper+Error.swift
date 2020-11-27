//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import MBNetworkKit

extension NetworkModelMapper {
	
	static func map(apiError: APIError) -> RegistrationError {
		return RegistrationError(description: apiError.description,
								 errors: self.map(apiErrorDescriptions: apiError.errors ?? []))
	}
	
	static func map(apiError: MBError) -> RegistrationError {
		return RegistrationError(description: apiError.localizedDescription,
								 errors: [])
	}
	
	// MARK: - Helper
	
	private static func map(apiErrorDescription: APIErrorDescription) -> RegistrationFieldError {
		return RegistrationFieldError(description: apiErrorDescription.description,
									  fieldName: apiErrorDescription.fieldName)
	}
	
	private static func map(apiErrorDescriptions: [APIErrorDescription]) -> [RegistrationFieldError] {
		return apiErrorDescriptions.map { self.map(apiErrorDescription: $0) }
	}
}
