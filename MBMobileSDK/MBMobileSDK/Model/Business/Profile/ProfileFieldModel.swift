//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of profile field
public struct ProfileFieldModel: Codable {
    
    public let sequenceOrder: Int
    public let fieldUsage: ProfileFieldUsage
    public var fieldValidation: ProfileFieldValidationModel?
    public var selectableValues: ProfileSelectableValuesModel?
    public var fieldId: ProfileFieldType {
        guard let fieldId = ProfileFieldType(rawValue: self.field) else {
			return .unknown
		}
		return fieldId
    }
    let field: String
    
    enum CodingKeys: String, CodingKey {
        case field = "fieldId"
        case sequenceOrder, fieldUsage, fieldValidation, selectableValues
    }
    
    public init(sequenceOrder: Int = 1,
                fieldUsage: ProfileFieldUsage = .optional,
                fieldValidation: ProfileFieldValidationModel? = nil,
                selectableValues: ProfileSelectableValuesModel? = nil,
                field: String) {
        self.sequenceOrder = sequenceOrder
        self.fieldUsage = fieldUsage
        self.fieldValidation = fieldValidation
        self.selectableValues = selectableValues
        self.field = field
    }
    
}


// MARK: - Extension

extension ProfileFieldModel {
	
	///
	/// Return description/value for specific field by a key
	///
	public func  selectableValueFor(key: String?) -> String? {
		return self.selectableValues?.selectableValues?.first(where: {$0.key == key})?.description
	}
}


// MARK: - Equatable

extension ProfileFieldModel: Equatable {
	
	public static func == (lhs: ProfileFieldModel, rhs: ProfileFieldModel) -> Bool {
        return lhs.fieldId.rawValue == rhs.fieldId.rawValue
	}
}

// MARK: - Hashable

extension ProfileFieldModel: Hashable {
	
	public func hash(into hasher: inout Hasher) {
        hasher.combine(self.fieldId.rawValue)
	}
}
