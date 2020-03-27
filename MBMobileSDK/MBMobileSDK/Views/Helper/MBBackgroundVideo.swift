//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit
import AVFoundation

public class MBBackgroundVideo {
    
    // MARK: - Properties
    
    var player: AVQueuePlayer!
    var looper: AVPlayerLooper!
    var playerLayer: AVPlayerLayer!
    
	
	// MARK: - Public
	
	public func play() {
		self.player.play()
	}
	
	public func pause() {
		self.player.pause()
	}
	
	
    // MARK: - Custom Init
    
    public init(mbVideo: MBFile, to view: UIView, dimAlpha: CGFloat = 0.6) {
		
        self.setupPlayer(videoUrl: mbVideo.url, view: view)
        self.startAudioSession()
        self.addDimLayer(alpha: dimAlpha, view: view)
    }
    
	
	// MARK: - Helper
	
    private func setupPlayer(videoUrl: URL, view: UIView) {
        
        let playerItem = AVPlayerItem(url: videoUrl)
        self.player = AVQueuePlayer(items: [playerItem])
        self.player.isMuted = true
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer.videoGravity = .resizeAspectFill
        self.looper = AVPlayerLooper(player: self.player, templateItem: playerItem)
        view.layer.insertSublayer(self.playerLayer, at: 0)
        self.playerLayer.frame = view.bounds
        self.player.play()
    }
    
    private func startAudioSession() {
        _ = try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [])
    }
    
    private func addDimLayer(alpha: CGFloat, view: UIView) {
        
        let dimLayer = CAShapeLayer()
        dimLayer.backgroundColor = UIColor.black.withAlphaComponent(alpha).cgColor
        dimLayer.frame = view.bounds
        view.layer.insertSublayer(dimLayer, at: 1)
    }
}
