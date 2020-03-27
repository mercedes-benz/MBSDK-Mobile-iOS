//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import UIKit

internal class PassthroughWindow: UIWindow {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}
