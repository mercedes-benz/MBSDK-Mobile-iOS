//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

class MBGradientSelectedDummyView: MBBaseView {
	
	let dummyGradientLayer = MBDummyGradientLayer()
	
	
	// MARK: - View life cycle
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.dummyGradientLayer.frame = self.bounds
	}
	
	override func setupUI() {
		super.setupUI()
		
		self.backgroundColor = .clear
		self.layer.addSublayer(self.dummyGradientLayer)
	}
}
