//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

extension MBViewStyle where T: UILabel {

    static func overline<T: UILabel>() -> MBViewStyle<T> {

        return MBViewStyle<T> { (label) in
            label.font = MBTypography.overline.font
        }
    }
}

class MBOverlineLabel: MBBaseLabel {
	
	override func setupUI() {
		
		self.apply(style: .overline())
	}
}
