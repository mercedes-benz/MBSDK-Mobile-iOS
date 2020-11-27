//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of profile field selection information
public struct ProfileSelectableValuesModel: Codable {
    public var matchSelectableValueByKey: Bool?
    public var defaultSelectableValueKey: String?
    public var selectableValues: [ProfileSelectableValueModel]?
}

/// Representation of profile field selection option
public struct ProfileSelectableValueModel: Codable {
    public var key, description: String
    
    public init(key: String, description: String) {
        
        self.key = key
        self.description = description
    }
}


// MARK: - Hashable

extension ProfileSelectableValueModel: Hashable {
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.key)
	}
}
