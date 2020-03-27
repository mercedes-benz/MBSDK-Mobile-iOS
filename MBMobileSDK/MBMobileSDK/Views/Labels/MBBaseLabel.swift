//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

class MBBaseLabel: UILabel {
	
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
		self.apply(style: .emphasized(.high))
    }
    
    // MARK: - Setup
    
    func commonInit() {
		self.setupUI()
    }
    
    func setupUI() {
        // override in subclass
    }
}
