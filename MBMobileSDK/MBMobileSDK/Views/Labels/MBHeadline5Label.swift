//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

extension MBViewStyle where T: UILabel {

    static func headline5<T: UILabel>() -> MBViewStyle<T> {

        return MBViewStyle<T> { (label) in
            label.font = MBTypography.h5.font
            }
    }

    static func headline5Serif<T: UILabel>() -> MBViewStyle<T> {

        return MBViewStyle<T> { (label) in
            label.font = MBTypography.h5Serif.font
            }
    }
}

class MBHeadline5Label: MBBaseLabel {
	
	override func setupUI() {
		self.apply(style: .headline5())
	}
}

class MBHeadlineSerif5Label: MBBaseLabel {

	override func setupUI() {
		self.apply(style: .headline5Serif())
	}
}
