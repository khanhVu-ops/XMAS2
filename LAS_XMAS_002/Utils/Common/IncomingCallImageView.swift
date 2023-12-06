//
//  IncomingCallImageView.swift
//  LAS_XMAS_002
//
//  Created by Khanh Vu on 10/11/2023.
//

import UIKit
import AVFAudio

class IncomingCallView: UIView {
    
    private var callIconCenter: CGPoint = CGPoint.zero
    private var callIconSize: CGFloat = 130.0
    private let imageView = UIImageView()
    var audioPlayer: AVAudioPlayer?
    var vibrateTimer: Timer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutIfNeeded()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        layoutIfNeeded()
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        callIconSize = frame.width
        callIconCenter = center
        stopIncomingCall()
        startIncomingCall()
        
        
        addObserver()
    }
    
    deinit {
        stopIncomingCall()
        removeObservers()
        
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    private func addRippleToCallIcon(diameterOffset: CGFloat, opacity: Double) {
        let duration: Double = 1.0
        let diameter: CGFloat = callIconSize
        let maxDiameter = diameter + diameterOffset
        let scale: CGFloat = maxDiameter / diameter
        
        let rippleLayer = CAShapeLayer()
        rippleLayer.frame = bounds
        let circlePath = UIBezierPath(ovalIn: CGRect(origin: .zero, size: frame.size))
        rippleLayer.path = circlePath.cgPath
        rippleLayer.fillColor = UIColor(hex: "#D8D8D8", alpha: 1).cgColor
        rippleLayer.opacity = Float(opacity)
        
        layer.addSublayer(rippleLayer)
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = duration
        animation.repeatCount = .infinity
        animation.fromValue = CGAffineTransform.identity
        animation.toValue = scale
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        rippleLayer.add(animation, forKey: nil)
        
    }
    
    private func addAnimtationImage() {
        imageView.frame = bounds
        imageView.layer.cornerRadius = imageView.frame.width / 2.0
        addSubview(imageView)
        bringSubviewToFront(imageView)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        let imageLayer = imageView.layer
        imageLayer.cornerRadius = imageView.frame.width / 2.0
        imageLayer.borderWidth = 3.0
        imageLayer.borderColor = UIColor.white.cgColor
        
        let imageAnimation = CABasicAnimation(keyPath: "transform.scale")
        imageAnimation.duration = 1.0
        imageAnimation.repeatCount = .infinity
        imageAnimation.fromValue = 1.15
        imageAnimation.toValue = 1.0
        imageAnimation.autoreverses = true
        imageAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        imageLayer.add(imageAnimation, forKey: nil)
    }
    
    private func stopRippleAnimation() {
//        if let rippleLayer = layer.sublayers?.first(where: { $0 is CAShapeLayer }) {
//            rippleLayer.removeAllAnimations()
//            rippleLayer.removeFromSuperlayer()
//        }
        
        if let subLayers = layer.sublayers?.filter({ $0 is CAShapeLayer }) {
            for subLayer in subLayers {
                subLayer.removeAllAnimations()
                subLayer.removeFromSuperlayer()
            }
        }
        
        imageView.layer.removeAllAnimations()
    }
    
    @objc func appDidEnterBackground() {
        stopRippleAnimation()
    }
    
    @objc func appWillEnterForeground() {
        addRippleToCallIcon(diameterOffset: 30.0, opacity: 0.13)
        addRippleToCallIcon(diameterOffset: 65.0, opacity: 0.13)
        addAnimtationImage()
    }
    
    
    // MARK: - Ring tone
    
    func startRingtone() {
        guard let url = Bundle.main.url(forResource: "ringtone", withExtension: "mp3") else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = 0
            audioPlayer?.delegate = self
            audioPlayer?.play()
        } catch {
            print("Failed to play ringtone: \(error.localizedDescription)")
        }
    }
    
    func stopRingtone() {
        audioPlayer?.stop()
    }
    
    
    //MARK: - Vibrate
    func startVibration() {
        vibrateTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(vibrate), userInfo: nil, repeats: true)
    }
    
    func stopVibration() {
            vibrateTimer?.invalidate()
            vibrateTimer = nil
        }
    
    @objc func vibrate() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
}

extension IncomingCallView {
    
    func startIncomingCall() {
        addRippleToCallIcon(diameterOffset: 30, opacity: 0.13)
        addRippleToCallIcon(diameterOffset: 65, opacity: 0.13)
        addAnimtationImage()
        startRingtone()
        startVibration()
    }
    
    func stopIncomingCall() {
        stopRippleAnimation()
        stopRingtone()
        stopVibration()
        removeObservers()
    }
    
    func setImageIncoming(image: UIImage?) {
        imageView.image = image
    }
}

extension IncomingCallView: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            // Wait for 0.5 second before restarting the ringtone
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.startRingtone()
            }
        }
    }
}
