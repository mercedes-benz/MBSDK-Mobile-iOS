//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

protocol MBButtonStyleProvider {

    ///Provides the text color for the button's title label and the given state.
    func titleColor(for state: UIButton.State) -> UIColor
    ///Provides the button's background color and the given state.
    func backgroundColor(for state: UIButton.State) -> UIColor
    ///Provides the button's border color and the given state.
    func borderColor(for state: UIButton.State) -> UIColor?
    ///This function can be implemented to apply further button customization.
    ///Will be executed after all implemented protocol requirements have been applied to the button.
    func customizeButton(_ button: MBBaseButton)
    ///Provides the tint color for the image set on the button's image view.
    var imageViewTintColor: UIColor { get }
    ///Provides the border width for the button's layer.
    var borderWidth: CGFloat { get }
}

extension MBButtonStyleProvider {

    func customizeButton(_ button: MBBaseButton) {

    }

    func backgroundColor(for state: UIControl.State) -> UIColor {
        return MBColorName.risWhite.color
    }

    func borderColor(for state: UIButton.State) -> UIColor? {
        return nil
    }

    var borderWidth: CGFloat {
        return 0.0
    }

    var imageViewTintColor: UIColor {
        return self.titleColor(for: .normal)
    }
}
