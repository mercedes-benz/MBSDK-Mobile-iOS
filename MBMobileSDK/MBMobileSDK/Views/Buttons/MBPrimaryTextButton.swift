//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

struct MBPrimaryTextButtonStyle: MBButtonStyleProvider {

    func titleColor(for state: UIControl.State) -> UIColor {
        return MBColorName.risAccentPrimary.color
    }

    func backgroundColor(for state: UIControl.State) -> UIColor {
        return .clear
    }
}

final class MBPrimaryTextButton: MBBaseButton {

    override func setupUI() {
        super.apply(style: .primaryText)
		self.loadingIndicatorStyle = .blue
    }
}
