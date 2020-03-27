//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

class MBErrorView: UIView {

    // MARK: - Outlets
    
    @IBOutlet private weak var errorImage: UIImageView!
    @IBOutlet private weak var errorMessageLabel: MBBody1Label!
    
    // MARK: - View Livecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }

    // MARK: - Setup UI
    
    private func setupUI() {
        
        self.errorImage.image = MBImageName.error.image
        self.errorImage.tintColor = MBColorName.risStatusError.color
    }
    
    // MARK: - Configuration
    
    func configure(errorMessage: String) {
        self.errorMessageLabel.text = errorMessage
    }
}
