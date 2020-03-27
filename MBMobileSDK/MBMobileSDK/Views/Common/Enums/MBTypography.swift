//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

enum MBTypography {
	case body1
	case body2
	case button1
	case caption
	case h4
	case h5
	case h4Serif
	case h5Serif
    case overline
	case subtitle1
	case subtitle2
}


// MARK: - Extension

extension MBTypography {
	
	var font: UIFont {
		switch self {
		case .h4:			return FontFamily.DaimlerCS.regular.font(size: 30)
		case .h5:			return FontFamily.DaimlerCS.regular.font(size: 26)
		case .h4Serif:		return FontFamily.DaimlerCAC.regular.font(size: 30)
		case .h5Serif:		return FontFamily.DaimlerCAC.regular.font(size: 26)
		case .overline:     return FontFamily.DaimlerCS.demi.font(size: 13)
		case .body1:		return FontFamily.DaimlerCS.regular.font(size: 16)
		case .body2:		return FontFamily.DaimlerCS.regular.font(size: 14)
		case .button1:		return FontFamily.DaimlerCS.demi.font(size: 18)
		case .caption:		return FontFamily.DaimlerCS.regular.font(size: 12)
		case .subtitle1:	return FontFamily.DaimlerCS.demi.font(size: 18)
		case .subtitle2:	return FontFamily.DaimlerCS.demi.font(size: 15)
		}
	}
}
