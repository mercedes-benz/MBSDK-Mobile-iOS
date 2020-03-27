//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

class MBGradientBlackView: MBBaseView {
	
	// MARK: Lazy
	private lazy var blackGradientLayer: MBBaseGradientLayer = {
		
		var gradient = MBBaseGradientLayer()
		
		gradient.colors = [
			MBColorName.risBlack.color.withAlphaComponent(0.4).cgColor,
			MBColorName.risBlack.color.withAlphaComponent(0).cgColor
		]
		gradient.direction = .bottomToTop
		
		return gradient
	}()
	
	// MARK: Enum
	enum Direction {
		case bottom
		case top
	}
	
	
	// MARK: - Public
	
	func set(direction: Direction) {
		
		switch direction {
		case .bottom:	self.blackGradientLayer.direction = .topToBottom
		case .top:		self.blackGradientLayer.direction = .bottomToTop
		}
	}
	
	
	// MARK: - View life cycle
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.blackGradientLayer.frame = self.bounds
	}
	
	override func setupUI() {
		super.setupUI()
		
		self.backgroundColor = .clear
		self.layer.addSublayer(self.blackGradientLayer)
	}
}
