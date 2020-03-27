//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

extension UIColor {
	
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    convenience init(netHex: Int) {
        self.init(red: (netHex >> 16) & 0xff, green: (netHex >> 8) & 0xff, blue: netHex & 0xff, alpha: 1.0)
    }
    
    convenience init(netHex: Int, alpha: CGFloat) {
        self.init(red: (netHex >> 16) & 0xff, green: (netHex >> 8) & 0xff, blue: netHex & 0xff, alpha: alpha)
    }
	
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

extension UIView {

	func setBackgroundColor(_ color: MBColorName) {
		self.backgroundColor = color.color
	}
}

extension UILabel {

	func setTextColor(_ color: MBColorName) {
		self.textColor = color.color
	}
}

extension UITextField {

	func setTextColor(_ color: MBColorName) {
		self.textColor = color.color
	}
}

extension UITextView {

	func setTextColor(_ color: MBColorName) {
		self.textColor = color.color
	}
}
