//
//  Copyright © 2018 Daimler AG. All rights reserved.
//

import UIKit

struct MBPlainButtonStyle: MBButtonStyleProvider {
    
    func titleColor(for state: UIControl.State) -> UIColor {
        return MBColorName.risWhite.color
    }
    
    func backgroundColor(for state: UIControl.State) -> UIColor {
        
        switch state {
        case .selected, .highlighted:
            return MBColorName.risAccentSecondary.color
            
        default:
            return MBColorName.risAccentPrimary.color
        }
    }
}

class MBPlainButton: MBBaseButton {
    
    // MARK: - Private Interface
    
    override func setupUI() {
        super.apply(style: .plain)
        self.loadingIndicatorStyle = .white
    }
}
