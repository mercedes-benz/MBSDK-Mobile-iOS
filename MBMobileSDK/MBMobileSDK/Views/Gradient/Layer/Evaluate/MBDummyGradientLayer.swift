//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

class MBDummyGradientLayer: MBBaseGradientLayer {
	
	override init() {
		super.init()
		
		self.colors = [
			UIColor.white.withAlphaComponent(0.1).cgColor,
			UIColor.clear.cgColor
		]
		self.direction = .leftToRight
		self.locations = [
			0.5,
			1.0
		]
	}
	
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
}
