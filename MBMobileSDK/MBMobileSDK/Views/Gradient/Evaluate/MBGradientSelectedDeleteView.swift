//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

class MBGradientSelectedDeleteView: MBBaseView {
	
	let blackGradientLayer = MBBlackDummyGradientLayer()
	let redGradientLayer   = MBRedDummyGradientLayer()
	
	
	// MARK: - View life cycle
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.blackGradientLayer.frame = self.bounds
		self.redGradientLayer.frame   = self.bounds
	}
	
	override func setupUI() {
		super.setupUI()
		
		self.backgroundColor = MBColorName.risGrey0.color
		self.layer.addSublayer(self.redGradientLayer)
		self.layer.addSublayer(self.blackGradientLayer)
	}
}
