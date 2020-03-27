//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

extension UIImage {

    static func mb_With(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage {

        return UIGraphicsImageRenderer(size: size).image { _ in
            color.setFill()
            UIBezierPath(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height)).fill()
        }
    }
    
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
		
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else {
			return nil
		}
        
        self.init(cgImage: cgImage)
    }
    
    func withInsets(_ insets: UIEdgeInsets) -> UIImage? {
		
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: size.width + insets.left + insets.right,
                   height: size.height + insets.top + insets.bottom),
            false,
            self.scale)
        
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageWithInsets
    }
}
