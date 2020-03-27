//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//


import UIKit

class MBBaseView: UIView {
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.commonInit()
    }
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.commonInit()
    }
    
    
    func commonInit() {
        
        self.mbLoadViewFromNib()
        self.setupUI()
    }
    
    
    // MARK: - Setup
    
    func setupUI() {
        
        // override in subclass
    }
}
