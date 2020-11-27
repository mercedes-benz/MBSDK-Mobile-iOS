//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//
import Foundation

/// Representation of exists user in backend
public struct UserExistModel: Equatable {
	
	public let isEmail: Bool?
	public let username: String
}
