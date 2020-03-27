//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

class MBGradientSelectedView: MBBaseView {
	
	let blackGradientLayer = MBBlackDummyGradientLayer()
	let blueGradientLayer = MBBlueDummyGradientLayer()
	
	
	// MARK: - View life cycle
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.blackGradientLayer.frame = self.bounds
		self.blueGradientLayer.frame  = self.bounds
	}
	
	override func setupUI() {
		super.setupUI()
		
		self.backgroundColor = MBColorName.risGrey0.color
		self.layer.addSublayer(self.blueGradientLayer)
		self.layer.addSublayer(self.blackGradientLayer)
	}
}
