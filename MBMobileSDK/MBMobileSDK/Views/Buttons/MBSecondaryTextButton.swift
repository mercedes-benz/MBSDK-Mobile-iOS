//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

struct MBSecondaryTextButtonStyle: MBButtonStyleProvider {

    func titleColor(for state: UIControl.State) -> UIColor {

        switch state {
        case .selected:
            return MBColorName.risAccentPrimary.color

        case .highlighted:
            return MBColorName.risWhite.color

        default:
            return MBColorName.risGrey2.color
        }
    }

    func backgroundColor(for state: UIControl.State) -> UIColor {

        switch state {
        case .selected, .highlighted:
            return MBColorName.risAccentSecondary.color

        default:
            return MBColorName.risWhite.color
        }
    }
}

final class MBSecondaryTextButton: MBBaseButton {

    override func setupUI() {
        super.apply(style: .secondaryText)
		self.loadingIndicatorStyle = .blue
    }
}
