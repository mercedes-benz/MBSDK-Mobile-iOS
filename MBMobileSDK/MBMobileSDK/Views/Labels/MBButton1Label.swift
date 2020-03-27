//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

extension MBViewStyle where T: UILabel {

    static func button1<T: UILabel>() -> MBViewStyle<T> {

        return MBViewStyle<T> { (label) in
            label.font = MBTypography.button1.font
		}
    }
}

class MBButton1Label: MBBaseLabel {
	
	override func setupUI() {
		self.apply(style: .button1())
	}
}
