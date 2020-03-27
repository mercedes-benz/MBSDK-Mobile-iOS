//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

extension MBViewStyle where T: UILabel {

    static func body1<T: UILabel>() -> MBViewStyle<T> {
        return MBViewStyle<T> { (label) in
            label.font = MBTypography.body1.font
            }
    }
}

class MBBody1Label: MBBaseLabel {

	override func setupUI() {
		self.apply(style: .body1())
	}
}
