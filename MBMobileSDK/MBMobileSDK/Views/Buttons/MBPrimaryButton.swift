//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

struct MBPrimaryButtonStyle: MBButtonStyleProvider {
    
    func titleColor(for state: UIControl.State) -> UIColor {
        return MBColorName.risWhite.color
    }
    
    func backgroundColor(for state: UIControl.State) -> UIColor {
        
        switch state {
        case .selected, .highlighted:
            return MBColorName.risAccentSecondary.color

        default:
            return UIColor(netHex: 0x0088C6)
        }
    }
}

class MBPrimaryButton: MBBaseButton {
  
    // MARK: - Private Interface
    
    override func setupUI() {
        super.apply(style: .primary)
        self.loadingIndicatorStyle = .white
    }
}
