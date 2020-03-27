//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

struct MBSecondaryButtonStyle: MBButtonStyleProvider {

    func titleColor(for state: UIControl.State) -> UIColor {
        return MBColorName.risAccentPrimary.color
    }

    var imageViewTintColor: UIColor? {
        return MBColorName.risAccentPrimary.color
    }

    func borderColor(for state: UIControl.State) -> UIColor? {

        switch state {
        case .highlighted:
            return MBColorName.risAccentSecondary.color

        default:
            return MBColorName.risAccentPrimary.color
        }
    }

    var borderWidth: CGFloat {
        return 1.0
    }
}

class MBSecondaryButton: MBBaseButton {


	// MARK: - Private Interface

	override func setupUI() {
        super.apply(style: .secondary)
		self.loadingIndicatorStyle = .blue
	}
}
