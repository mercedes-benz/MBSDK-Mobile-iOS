//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

extension UILabel: MBStylable {}

extension UILabel {

    enum MBEmphasisType {
        case high
        case low
        case medium

        var color: UIColor {
            switch self {
            case .high:		return MBColorName.risGrey0.color
            case .low:		return MBColorName.risWhite.color
            case .medium:	return MBColorName.risGrey2.color
            }
        }
    }
}

extension MBViewStyle where T: UILabel {

    static func emphasized<T: UILabel>(_ emphasis: UILabel.MBEmphasisType) -> MBViewStyle<T> {
        return MBViewStyle<T> { (label) in
            label.textColor = emphasis.color
        }
    }

    ///Sets the label's text color according to the color name passed as an argument.
    static func textColor<T: UILabel>(_ textColor: MBColorName) -> MBViewStyle<T> {
        return .textColor(textColor.color)
    }

    ///Sets the label's text color according to the color passed as an argument.
    private static func textColor<T: UILabel>(_ textColor: UIColor) -> MBViewStyle<T> {
        return MBViewStyle<T> { (label) in
            label.textColor = textColor
        }
    }

    ///Sets the label's text color according to the status type passed as an argument.
    static func statusText<T: UILabel>(type: UIView.MBStatusType) -> MBViewStyle<T> {
        return .textColor(type.color)
    }

    ///Sets the label's text and background color according to the status type passed as an argument.
    static func status<T: UILabel>(type: UIView.MBStatusType) -> MBViewStyle<T> {
        return self.statusBackground(type: type).compose(with: .textColor(.white))
    }
}
