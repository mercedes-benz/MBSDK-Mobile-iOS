//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import RealmSwift
import MBRealmKit

class CommandCapabilitiesDbModelMapper: DbModelMapping {
	
	typealias BusinessModel = CommandCapabilitiesModel
	typealias DbModel = DBVehicleCommandCapabilitiesModel
	
	func map(_ dbModel: DBVehicleCommandCapabilitiesModel) -> CommandCapabilitiesModel {
		
		let capabilities = self.map(dbModel.capabilities)
		return CommandCapabilitiesModel(capabilities: capabilities,
										finOrVin: dbModel.finOrVin)
	}
	
	func map(_ businessModel: CommandCapabilitiesModel) -> DBVehicleCommandCapabilitiesModel {
		
		let dbModel = DBVehicleCommandCapabilitiesModel()
		dbModel.capabilities.append(objectsIn: self.map(businessModel.capabilities))
		dbModel.finOrVin = businessModel.finOrVin
		return dbModel
	}
	
	
	// MARK: - Helper
	
	private func map(_ commandCapabilityModel: CommandCapabilityModel) -> DBVehicleCommandCapabilityModel {
		
		let dbVehicleCommandCapabilityModel = DBVehicleCommandCapabilityModel()
		dbVehicleCommandCapabilityModel.additionalInformation = commandCapabilityModel.additionalInformation.joined(separator: ",")
		dbVehicleCommandCapabilityModel.commandName = commandCapabilityModel.commandName.rawValue
		dbVehicleCommandCapabilityModel.isAvailable = commandCapabilityModel.isAvailable
		
		dbVehicleCommandCapabilityModel.parameters.removeAll()
		dbVehicleCommandCapabilityModel.parameters.append(objectsIn: self.map(commandCapabilityModel.parameters))
		
		return dbVehicleCommandCapabilityModel
	}
	
	private func map(_ commandCapabilityModels: [CommandCapabilityModel]) -> [DBVehicleCommandCapabilityModel] {
		return commandCapabilityModels.map { self.map($0) }
	}
	
	private func map(_ commandParameterModel: CommandParameterModel) -> DBVehicleCommandParameterModel {
		
		let dbVehicleCommandParameterModel = DBVehicleCommandParameterModel()
		dbVehicleCommandParameterModel.allowedBool = commandParameterModel.allowedBools.rawValue
		dbVehicleCommandParameterModel.allowedEnums = commandParameterModel.allowedEnums.map { $0.rawValue }.joined(separator: ",")
		dbVehicleCommandParameterModel.maxValue = commandParameterModel.maxValue
		dbVehicleCommandParameterModel.minValue = commandParameterModel.minValue
		dbVehicleCommandParameterModel.parameterName = commandParameterModel.parameterName.rawValue
		dbVehicleCommandParameterModel.steps = commandParameterModel.steps
		return dbVehicleCommandParameterModel
	}
	
	private func map(_ commandParameterModels: [CommandParameterModel]) -> [DBVehicleCommandParameterModel] {
		return commandParameterModels.map { self.map($0) }
	}
	
	private func map(_ dbVehicleCommandCapabilityModel: DBVehicleCommandCapabilityModel) -> CommandCapabilityModel {
		
		let additional = dbVehicleCommandCapabilityModel.additionalInformation.components(separatedBy: ",")
		let commandName = CommandName(rawValue: dbVehicleCommandCapabilityModel.commandName) ?? .unknown
		let parameters: [CommandParameterModel] = dbVehicleCommandCapabilityModel.parameters.map { self.map($0) }
		
		return CommandCapabilityModel(additionalInformation: additional,
									  commandName: commandName,
									  isAvailable: dbVehicleCommandCapabilityModel.isAvailable,
									  parameters: parameters)
	}
	
	private func map(_ dbVehicleCommandCapabilityList: List<DBVehicleCommandCapabilityModel>) -> [CommandCapabilityModel] {
		return dbVehicleCommandCapabilityList.map { self.map($0) }
	}
	
	private func map(_ dbVehicleCommandParameterModel: DBVehicleCommandParameterModel) -> CommandParameterModel {
		
		let allowedBool = CommandAllowedBool(rawValue: dbVehicleCommandParameterModel.allowedBool) ?? .unknown
		let allowedEnums = dbVehicleCommandParameterModel.allowedEnums.components(separatedBy: ",").compactMap { CommandAllowedEnum(rawValue: $0) }
		let parameterName = CommandParameterName(rawValue: dbVehicleCommandParameterModel.parameterName) ?? .unknown
		
		return CommandParameterModel(allowedBools: allowedBool,
									 allowedEnums: allowedEnums,
									 maxValue: dbVehicleCommandParameterModel.maxValue,
									 minValue: dbVehicleCommandParameterModel.minValue,
									 parameterName: parameterName,
									 steps: dbVehicleCommandParameterModel.steps)
	}
}
