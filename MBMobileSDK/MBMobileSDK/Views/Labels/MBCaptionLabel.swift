//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

extension MBViewStyle where T: UILabel {

    static func caption<T: UILabel>() -> MBViewStyle<T> {

        return MBViewStyle<T> { (label) in
            label.font = MBTypography.caption.font
            }
    }
}

class MBCaptionLabel: MBBaseLabel {
	
	override func setupUI() {
		self.apply(style: .caption())
	}
}
