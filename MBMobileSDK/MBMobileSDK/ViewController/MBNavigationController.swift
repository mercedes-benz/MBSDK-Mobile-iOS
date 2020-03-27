//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

class MBNavigationController: UINavigationController {
        
    // MARK: - View Lifecycle

    open override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAppearance()
        
        self.delegate = self
    }

    // MARK: - User Interface
    
    private func setupAppearance() {
		
        let titleColor = MBColorName.risWhite.color
        let titleFont = MBTypography.subtitle1.font
        let textAttributes = [
            NSAttributedString.Key.foregroundColor: titleColor,
            NSAttributedString.Key.font: titleFont
        ]
        
        self.modalPresentationStyle = .fullScreen
        
        self.navigationBar.titleTextAttributes  = textAttributes
        
        if #available(iOS 11.0, *) {
            let largeTitleFont: UIFont = MBTypography.h5.font
            let largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: titleColor,
                NSAttributedString.Key.font: largeTitleFont
            ]
            
            self.navigationBar.largeTitleTextAttributes = largeTitleTextAttributes
        }

        self.navigationBar.barTintColor = MBColorName.risBlack.color
        self.navigationBar.tintColor = MBColorName.risWhite.color
        self.navigationBar.isTranslucent = false

        self.setupBackButton()
    }
    
    private func setupBackButton() {
		
        let backButtonImage = MBImageName.chevronLeft.image.withInsets(UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0))
        
        self.navigationBar.backIndicatorImage = backButtonImage
        self.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
    }
}


// MARK: - UINavigationControllerDelegate

extension MBNavigationController: UINavigationControllerDelegate {
	
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    }
}
