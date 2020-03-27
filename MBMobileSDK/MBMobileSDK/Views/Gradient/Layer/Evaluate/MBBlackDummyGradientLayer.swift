//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

class MBBlackDummyGradientLayer: MBBaseGradientLayer {
	
	override init() {
		super.init()
		
		self.colors = [
			MBColorName.risBlack.color.withAlphaComponent(0.55).cgColor,
			UIColor.clear.cgColor,
			UIColor.clear.cgColor,
			UIColor.clear.cgColor,
			MBColorName.risBlack.color.withAlphaComponent(0.55).cgColor
		]
		self.direction = .rightToLeft
	}
	
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
}
