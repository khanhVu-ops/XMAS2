//
//  PlayerLayerView.swift
//  LAS_MOVIE_003
//
//  Created by Khanh Vu on 28/08/2023.
//

import UIKit
import AVFoundation

class PlayerLayerView: UIView {
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    //closure
    var actionPlaybackEnd: (() -> Void)?
    var actionAppEnterBackground: (() -> Void)?
    var onTimeObserver: ((Double) -> Void)?
    
    private var playerItem: AVPlayerItem?
    var timeObserver: Any?

    var isPlaybackEnd = false
    var isPlaying: Bool {
        return player?.rate != 0
    }
    
    var volume: Float = 1.0 {
        didSet {
            player?.volume = volume
        }
    }
    
    var currentRate: Float = 1.0 {
        didSet {
            if isPlaying {
                player?.rate = currentRate
            }
        }
    }
    
    var rotation: CGFloat = 0 {
        didSet {
            rotate()
        }
    }
    
    // start, end time playing
    var startTime: Double = 0.0
    var endTime: Double = 0.0
    
    //MAKR: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setUpUI()
    }
    
    //MAR: - deinit
    deinit {
        print("deinit player")
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        removeTimeObserver()
    }
    
    //MARK: - private
    private func setUpUI() {
        // Observe state end playback
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(_:)), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        // Observe app's active state changes
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
    
    private func setUpAsset(with url: URL, completion: ((_ asset: AVAsset) -> Void)?) {
        let asset = AVAsset(url: url)
        asset.loadValuesAsynchronously(forKeys: ["playable"]) {
            var error: NSError? = nil
            let status = asset.statusOfValue(forKey: "playable", error: &error)
            switch status {
            case .loaded:
                completion?(asset)
            case .failed:
                print(".failed")
            case .cancelled:
                print(".cancelled")
            default:
                print("default")
            }
        }
    }
    
    // add time observer
    private func addPeriodicTimeObserver() {
        let interval = CMTime(value: 1, timescale: 100)
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            
            guard let self = self, let onTimeObserver = self.onTimeObserver else { return }
            onTimeObserver(CMTimeGetSeconds(time))
        }
    }
    
    //remove observer
    private func removeTimeObserver() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
    
    private func rotate() {

        let corner = rotation.truncatingRemainder(dividingBy: 360.0)
        let transform = CGAffineTransform(rotationAngle: degreeToRadian(corner))
        
        playerLayer.setAffineTransform(transform)

        let bounds = playerLayer.bounds.size.applying(transform)
        var newSize: CGSize
        if corner == 180 || corner == 0 {
            newSize = CGSize(width: bounds.height, height: bounds.width)
        } else {
            newSize = bounds
        }
        playerLayer.bounds = CGRect(origin: .zero, size: newSize)
    }
    
    private func degreeToRadian(_ x: CGFloat) -> CGFloat {
        return .pi * x / 180.0
    }
    
    //MARK: - public
    
    // load video avplayer
    func load(with asset: AVAsset, completion: ((Double) -> Void)?) {
        playerItem = AVPlayerItem(asset: asset)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.player = AVPlayer(playerItem: self.playerItem!)
            self.pauseVideo()
            let duration = asset.duration.seconds
            self.endTime = duration
            self.addPeriodicTimeObserver()
            completion?(duration)
        }
    }
    
    func load(with url: URL, completion: ((Double) -> Void)?) {
        print(url)
        setUpAsset(with: url) { [weak self] (asset: AVAsset) in
            self?.load(with: asset, completion: { duration in
                completion?(duration)
            })
        }
    }
    
    // seek
    func seekTo(_ time: CMTime) {
        player?.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    func seekTo(_ time: Double) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 100)
        seekTo(cmTime)
    }
    
    // get current time
    func getCurrentTime() -> Double {
        guard let cmTime = player?.currentTime() else {
            return 0
        }
        return CMTimeGetSeconds(cmTime)
    }
    
    // play
    func playVideo() {
        if isPlaybackEnd &&  player?.currentTime() == player?.currentItem?.duration {
            seekTo(CMTime(seconds: 0, preferredTimescale: 100))
            isPlaybackEnd = false
        }
        player?.play()
        player?.rate = currentRate
        player?.volume = volume
    }
    
    func playVideo(_ start: Double, _ end: Double) {
        guard let currentTime = player?.currentTime() else {
            return
        }
        if Int(CMTimeGetSeconds(currentTime)) == Int(end) {
            seekTo(CMTime(seconds: start, preferredTimescale: 100))
        }
        player?.play()
        player?.rate = currentRate
    }
    
    // pause
    func pauseVideo() {
        player?.pause()

    }
    
    // hidden player
    func setHiddenVideoPlayer(isHidden: Bool) {
        playerLayer.isHidden = isHidden
    }
    
    //MARK: - objc func
    // playback end
    @objc func playerItemDidReachEnd(_ notification: Notification) {
        isPlaybackEnd = true
        pauseVideo()
        if let actionPlaybackEnd = actionPlaybackEnd {
            actionPlaybackEnd()
        }
    }
    
    // app enter background
    @objc func appEnterBackground() {
        pauseVideo()
        if let actionAppEnterBackground = actionAppEnterBackground {
            actionAppEnterBackground()
        }
    }

    
    // preview click
    @objc func previewClicked() {
        if isPlaying {
            pauseVideo()
        } else {
            playVideo()
        }
        
    }
}
