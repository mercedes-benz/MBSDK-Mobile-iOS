//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

internal class MBRadialGradientLayer: CALayer {
    var colors: [CGColor]?
    
    var locations: [CGFloat]?
    
    var startPoint: CGPoint?
    var endPoint: CGPoint?
    
    override func draw(in context: CGContext) {
        
        guard let colors = self.colors, let locations = self.locations else {
            return
        }
        
        let p1 = CGPoint(
            x: self.startPoint?.x ?? 0.5,
            y: self.startPoint?.y ?? 0.5
        )
        let p2 = CGPoint(
            x: self.endPoint?.x ?? p1.x,
            y: self.endPoint?.y ?? p1.y
        )
        
        let viewPoint1 = CGPoint(
            x: self.bounds.width*p1.x,
            y: self.bounds.height*p1.y
        )
        let viewPoint2 = CGPoint(
            x: self.bounds.width*p2.x,
            y: self.bounds.height*p2.y
        )
        
        let radius = max(
            sqrt(pow(viewPoint1.x, 2)+pow(viewPoint2.x, 2)),
            sqrt(pow(viewPoint1.y, 2)+pow(viewPoint2.y, 2))
        )
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let cfColors = colors as CFArray
        let gradient = CGGradient(colorsSpace: colorSpace, colors: cfColors, locations: locations)
        
        context.drawRadialGradient(
            gradient!,
            startCenter: viewPoint1, startRadius: 0,
            endCenter: viewPoint1, endRadius: radius,
            options: .drawsAfterEndLocation
        )
    }
    
}
