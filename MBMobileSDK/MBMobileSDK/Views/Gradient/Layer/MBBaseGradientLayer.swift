//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

class MBBaseGradientLayer: CAGradientLayer {
	
	var direction: MBGradientDirection = .bottomToTop {
		didSet {
			self.setupDirection()
		}
	}
	
	
	// MARK: - Init

	override init() {
		super.init()
		
		self.commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
        
        self.commonInit()
	}
    
    override init(layer: Any) {
        super.init(layer: layer)
        
        self.commonInit()
    }
    
    func commonInit() {
        self.setupDirection()
    }
	
	// MARK: - Helper
	
	private func setupDirection() {
		
		switch self.direction {
		case .leftToRight:
			self.startPoint = CGPoint(x: 0.0, y: 0.5)
			self.endPoint   = CGPoint(x: 1.0, y: 0.5)
			
		case .rightToLeft:
			self.startPoint = CGPoint(x: 1.0, y: 0.5)
			self.endPoint   = CGPoint(x: 0.0, y: 0.5)
			
		case .topToBottom:
			self.startPoint = CGPoint(x: 0.5, y: 0.0)
			self.endPoint   = CGPoint(x: 0.5, y: 1.0)
			
		case .bottomToTop:
			self.startPoint = CGPoint(x: 0.5, y: 1.0)
			self.endPoint   = CGPoint(x: 0.5, y: 0.0)
		}
	}
}
