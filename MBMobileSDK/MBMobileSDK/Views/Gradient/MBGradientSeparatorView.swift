//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

class MBGradientSeparatorView: MBBaseView {
	
	let separatorGradientLayer = MBSeparatorGradientLayer()
	
	
	// MARK: - View life cycle
	
	override func layoutSubviews() {
		super.layoutSubviews()

		self.separatorGradientLayer.frame = self.bounds
	}

	override func setupUI() {
		super.setupUI()

		self.backgroundColor = .clear
		self.layer.addSublayer(self.separatorGradientLayer)
	}
}
