//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - Dealer Search

extension NetworkModelMapper {
	
	// MARK: - BusinessModel
	
	static func map(apiCommandCapabilityModels: [APICommandCapabilityModel], finOrVin: String) -> CommandCapabilitiesModel {
		
		let capabilities = self.map(apiCommandCapabilityModels: apiCommandCapabilityModels)
		return CommandCapabilitiesModel(capabilities: capabilities,
										finOrVin: finOrVin)
	}
	
	
	// MARK: - Helper
	
	private static func map(apiCommandCapabilityModel: APICommandCapabilityModel) -> CommandCapabilityModel {
		
		let commandName = CommandName(rawValue: apiCommandCapabilityModel.commandName ?? "") ?? .unknown
		let parameters: [CommandParameterModel] = {
			
			guard let apiCommandParameterModels = apiCommandCapabilityModel.parameters else {
				return []
			}
			return self.map(apiCommandParameterModels: apiCommandParameterModels)
		}()
		
		return CommandCapabilityModel(additionalInformation: apiCommandCapabilityModel.additionalInformation ?? [],
									  commandName: commandName,
									  isAvailable: apiCommandCapabilityModel.isAvailable ?? false,
									  parameters: parameters)
	}
	
	private static func map(apiCommandCapabilityModels: [APICommandCapabilityModel]) -> [CommandCapabilityModel] {
		return apiCommandCapabilityModels.map { self.map(apiCommandCapabilityModel: $0) }
	}
	
	private static func map(apiCommandParameterModel: APICommandParameterModel) -> CommandParameterModel {
		
		let allowedBool = CommandAllowedBool(rawValue: apiCommandParameterModel.allowedBools ?? "") ?? .unknown
		let allowedEnums = apiCommandParameterModel.allowedEnums?.compactMap { CommandAllowedEnum(rawValue: $0) } ?? []
		let parameterName = CommandParameterName(rawValue: apiCommandParameterModel.parameterName ?? "") ?? .unknown
		
		return CommandParameterModel(allowedBools: allowedBool,
									 allowedEnums: allowedEnums,
                                     maxValue: apiCommandParameterModel.maxValue ?? 0.0,
                                     minValue: apiCommandParameterModel.minValue ?? 0.0,
									 parameterName: parameterName,
                                     steps: apiCommandParameterModel.steps ?? 0.0)
	}
	
	private static func map(apiCommandParameterModels: [APICommandParameterModel]) -> [CommandParameterModel] {
		return apiCommandParameterModels.map { self.map(apiCommandParameterModel: $0) }
	}
}
