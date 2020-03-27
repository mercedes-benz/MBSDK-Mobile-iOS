//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

extension MBViewStyle where T: UILabel {

    static func headline4<T: UILabel>() -> MBViewStyle<T> {

        return MBViewStyle<T> { (label) in
            label.font = MBTypography.h4.font
            }
    }

    static func headline4Serif<T: UILabel>() -> MBViewStyle<T> {

        return MBViewStyle<T> { (label) in
            label.font = MBTypography.h4Serif.font
            }
    }
}

class MBHeadline4Label: MBBaseLabel {
	
	override func setupUI() {
		self.apply(style: .headline4())
	}
}

class MBHeadlineSerif4Label: MBBaseLabel {

	override func setupUI() {
		self.apply(style: .headline4Serif())
	}
}
