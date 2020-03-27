//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

extension MBViewStyle where T: UILabel {

    static func subtitle2<T: UILabel>() -> MBViewStyle<T> {

        return MBViewStyle<T> { (label) in
            label.font = MBTypography.subtitle2.font
            }
    }
}

class MBSubtitle2Label: MBBaseLabel {
	
	override func setupUI() {
		self.apply(style: .subtitle2())
	}
}
