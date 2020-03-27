//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

class MBBlueDummyGradientLayer: MBBaseGradientLayer {
	
	override init() {
		super.init()
		
		self.colors = [
			MBColorName.risAccentPrimary.color.cgColor,
			MBColorName.risAccentPrimary.color.withAlphaComponent(0.25).cgColor,
			MBColorName.risAccentPrimary.color.withAlphaComponent(0.15).cgColor,
			MBColorName.risAccentPrimary.color.withAlphaComponent(0.25).cgColor,
			MBColorName.risAccentPrimary.color.withAlphaComponent(0.6).cgColor
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
