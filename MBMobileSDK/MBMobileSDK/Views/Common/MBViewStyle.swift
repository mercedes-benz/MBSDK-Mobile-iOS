//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

protocol MBStylable {}

extension UIView {

    enum MBStatusType {
        case success
        case medium
        case error

        var color: UIColor {
            switch self {
            case .success:
                return MBColorName.risStatusSuccess.color
            case .medium:
                return MBColorName.risStatusMedium.color
            case .error:
                return MBColorName.risStatusError.color
            }
        }
    }
}

extension MBStylable where Self: UIView {

    ///Styles the view according to the style passed as an argument.
    func apply(style: MBViewStyle<Self>) {
        style.style(self)
    }
}

struct MBViewStyle<T: UIView & MBStylable> {

    internal let style: (T) -> Void

    init(style: @escaping (T) -> Void) {
        self.style = style
    }
    
    ///Appends the style passed as an argument.
    func compose(with style: MBViewStyle<T>) -> MBViewStyle<T> {
        return MBViewStyle<T> {

            self.style($0)
            style.style($0)
        }
    }

    ///Sets the view's background color according to the status type passed as an argument.
    static func statusBackground<T: UILabel>(type: UIView.MBStatusType) -> MBViewStyle<T> {
        return .backgroundColor(type.color)
    }

    ///Sets the view's background color according to the color name passed as an argument.
    static func backgroundColor<T: UIView & MBStylable>(_ backgroundColor: MBColorName) -> MBViewStyle<T> {
        return .backgroundColor(backgroundColor.color)
    }

    ///Sets the view's background color according to the color passed as an argument.
    internal static func backgroundColor<T: UIView & MBStylable>(_ backgroundColor: UIColor) -> MBViewStyle<T> {
        return MBViewStyle<T> { (view) in
            view.backgroundColor = backgroundColor
        }
    }
}
