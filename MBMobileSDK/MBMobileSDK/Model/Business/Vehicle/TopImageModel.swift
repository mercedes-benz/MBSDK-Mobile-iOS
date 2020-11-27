//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBRealmKit


// MARK: - TopImageModel

public struct TopImageModel {
    
	public let vin: String
    public let components: [TopImageComponentModel]
}

extension TopImageModel: Entity {
	
	public var id: String {
		return self.vin
	}
}


// MARK: - TopImageComponentModel

public struct TopImageComponentModel {
    public let name: String
    public let imageData: Data?
}
