//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

extension MBViewStyle where T: UILabel {

    static func body2<T: UILabel>() -> MBViewStyle<T> {

        return MBViewStyle<T> { (label) in
            label.font = MBTypography.body2.font
            }
    }
}

class MBBody2Label: MBBaseLabel {
	
	override func setupUI() {
		self.apply(style: .body2())
	}
}
