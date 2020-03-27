//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

class MBSeparatorView: MBBaseView {
	
	// MARK: - View life cycle
	
	override func setupUI() {
		super.setupUI()
		
		self.backgroundColor = MBColorName.risGrey3.color
	}

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 1 / UIScreen.main.scale)
    }
}
