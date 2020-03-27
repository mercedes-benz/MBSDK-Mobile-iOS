//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

class MBRedDummyGradientLayer: MBBaseGradientLayer {
	
	override init() {
		super.init()
		
		self.colors = [
			UIColor.red,
			UIColor.red.withAlphaComponent(0.25).cgColor,
			UIColor.red.withAlphaComponent(0.15).cgColor,
			UIColor.red.withAlphaComponent(0.25).cgColor,
			UIColor.red.withAlphaComponent(0.6).cgColor
		]
		self.direction = .bottomToTop
	}
	
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
}
