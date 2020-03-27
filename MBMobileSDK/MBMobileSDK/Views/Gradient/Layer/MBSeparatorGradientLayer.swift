//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

class MBSeparatorGradientLayer: MBBaseGradientLayer {
	
	override init() {
		super.init()
		
		self.colors = [
			MBColorName.risGrey0.color.withAlphaComponent(0).cgColor,
			MBColorName.risGrey0.color.cgColor,
			MBColorName.risGrey0.color.cgColor,
			MBColorName.risGrey0.color.withAlphaComponent(0).cgColor
		]
		self.direction = .rightToLeft
		self.locations = [
			0.0,
			0.3,
			0.7,
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
