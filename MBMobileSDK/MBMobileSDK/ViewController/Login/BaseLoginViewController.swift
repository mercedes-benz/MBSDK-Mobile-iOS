//
// Copyright (c) 2020 MBition GmbH. All rights reserved.
//

import UIKit

open class BaseLoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private var bgVideo: MBBackgroundVideo?
    
    
    // MARK: - View Lifecycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setupAccessibility()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        UIApplication.willEnterForegroundNotification.add(self, selector: #selector(self.playVideo))
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.playVideo()
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.pauseVideo()
        UIApplication.willEnterForegroundNotification.remove(self)
    }
    
    
    // MARK: - Oberserver
    
    @objc private func pauseVideo() {
        self.bgVideo?.pause()
    }
    
    @objc private func playVideo() {
        self.bgVideo?.play()
    }
    
    
    // MARK: - Setup
    
    func setupAccessibility() {
        self.view.accessibilityIdentifier = L10n.IdentifierUI.loginView
    }
    
    func setupUI() {
        
        self.view.backgroundColor = .black
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.bgVideo = MBBackgroundVideo(mbVideo: MBFile.Video.welcomeCompressed, to: self.view, dimAlpha: 0.2)
    }
}
