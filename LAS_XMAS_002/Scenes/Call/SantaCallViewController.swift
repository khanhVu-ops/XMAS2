//
//  VideoNoteViewController.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 12/10/2023.
//

import UIKit
import RxSwift
import RxCocoa
import AudioToolbox

class SantaCallViewController: BaseViewController {
    
    //MARK: - Outlet
    // Incoming call
    @IBOutlet weak var statusCallingView: UIStackView!
    @IBOutlet weak var santaClausLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var incomingCallView: IncomingCallView!
    
    @IBOutlet weak var refuseAndAcceptView: UIView!
    @IBOutlet weak var acceptIncomingButton: UIButton!
    @IBOutlet weak var refuseIncomingButton: UIButton!
    
    // Audio call
    @IBOutlet weak var audioCallButtonView: UIView!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var speakerButton: UIButton!
    @IBOutlet weak var openVideoButton: UIButton!
    @IBOutlet weak var cancelAudioCallButton: UIButton!
    
    // Video call
    @IBOutlet weak var previewVideoView: PlayerLayerView!
    @IBOutlet weak var videoCallButtonView: UIView!
    @IBOutlet weak var cancelVideoCallButton: UIButton!
    @IBOutlet weak var microVideoCallButton: UIButton!
    @IBOutlet weak var rotateCameraButton: UIButton!
    
    //MARK: - Property
    var cameraView = PreviewCameraView()
    var viewModel: SantaCallViewModel
    let disposeBag = DisposeBag()
    var callCanceledTrigger = PublishSubject<Void>()
    var showSettingCameraTrigger = PublishSubject<Void>()
    
    // constant
    let spacingSuperView: CGFloat = 25
    let cameraViewSize = CGSize(width: 150, height: 200)
    let spaceBottom = 135.0
    let spaceTop = 40.0
    
    // Volunm
    let volumn: Float = 0.2
    let volumnEnable: Float = 1.0
    //MARK: - Life Cycle
    
    init(viewModel: SantaCallViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraView.stopSession()
    }

    //MARK: - Private
    private func setUpUI() {
        view.backgroundColor = .backgroundColor
        
        // video call
        videoCallButtonView.backgroundColor = .black.withAlphaComponent(0.58)
        statusLabel.setShadow(offset: CGSize(width: 1, height: 1), radius: 3, color: .black, opacity: 0.3)
        santaClausLabel.setShadow(offset: CGSize(width: 1, height: 1), radius: 3, color: .black, opacity: 0.3)
        // Preview view
        previewVideoView.playerLayer.videoGravity = .resizeAspectFill
        self.previewVideoView.volume = volumn

        previewVideoView.onTimeObserver = { [weak self] time in
            guard let self = self else {
                return
            }
            
            self.statusLabel.text = Int(time).secondsToHoursMinutesSeconds()
        }
         
        previewVideoView.actionPlaybackEnd = { [weak self]  in
            guard let self = self else {
                return
            }
//            self.callCanceledTrigger.onNext(())
            self.previewVideoView.playVideo()
        }
        
        previewVideoView.actionAppEnterBackground = { [weak self]  in
            guard let self = self else {
                return
            }
            self.callCanceledTrigger.onNext(())
        }
        
        // Camera view
        cameraView.onShowAlertSettingCamera = { [weak self]  in
            guard let self = self else {
                return
            }
            self.showSettingCameraTrigger.onNext(())
        }
    }
    
    private func setupCameraView() {
        view.addSubview(cameraView)
        cameraView.backgroundColor = .white
        let x = view.frame.width - cameraViewSize.width - spacingSuperView
        let y = view.frame.height - cameraViewSize.height - spaceBottom
        cameraView.frame = CGRect(x: x, y: y, width: cameraViewSize.width, height: cameraViewSize.height)
        cameraView.setLayout(radius: 30, borderWidth: 3, borderColor: .white)
        cameraView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanCameraView(_:))))
        cameraView.startSession()
    }
    
    private func bindViewModel() {
        let input = SantaCallViewModel.Input(loadTrigger: Driver.just(()),
                                             refuseIncomingTrigger: refuseIncomingButton.rx.impactTap.asDriver(),
                                             acceptIncomingTrigger: acceptIncomingButton.rx.impactTap.asDriver(),
                                             muteTrigger: muteButton.rx.impactTap.asDriver(),
                                             speakerTrigger: speakerButton.rx.impactTap.asDriver(),
                                             openVideoTrigger: openVideoButton.rx.impactTap.asDriver(),
                                             cancelAudioCallTrigger: cancelAudioCallButton.rx.impactTap.asDriver(),
                                             cancelVideoCallTrigger: cancelVideoCallButton.rx.impactTap.asDriver(),
                                             microVideoCallTrigger: microVideoCallButton.rx.impactTap.asDriver(),
                                             rotateCameraTrigger: rotateCameraButton.rx.impactTap.asDriver(),
                                             callCanceledTrigger: callCanceledTrigger.asDriverComplete(),
                                             showSettingCameraTrigger: showSettingCameraTrigger.asDriverComplete())
        
        let output = viewModel.transform(input)
        
        output.error.asDriver()
            .drive(onNext: { error in
                if let appError = error as? AppError {
                    Toast.show(appError.message)
                } else {
                    Toast.show(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
        
        output.loading.asObservable()
            .bind(to: ActivityIndicatorUtility().rx_progresshud_animating)
            .disposed(by: disposeBag)
        
        output.loadTrigger
            .drive()
            .disposed(by: disposeBag)
        
        output.santaCallType
            .drive ( onNext: { [weak self] callType in
                self?.updateCallType(callType: callType)
            })
            .disposed(by: disposeBag)
        
        output.refuseIncomingTrigger
            .drive( onNext: { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.incomingCallView.stopIncomingCall()
            })
            .disposed(by: disposeBag)
        
        output.acceptIncomingTrigger
            .drive( onNext: { [weak self] url in
                guard let self = self else {
                    return
                }
                self.incomingCallView.stopIncomingCall()
                self.previewVideoView.load(with: url) { _ in
                    self.previewVideoView.playVideo()
                }
            })
            .disposed(by: disposeBag)
        
        output.muteTrigger
            .drive()
            .disposed(by: disposeBag)
        
        output.speakerTrigger
            .drive()
            .disposed(by: disposeBag)
        
        output.openVideoTrigger
            .drive()
            .disposed(by: disposeBag)
        
        output.microVideoCallTrigger
            .drive()
            .disposed(by: disposeBag)
        
        output.rotateCameraTrigger
            .drive( onNext: { [weak self] in
                self?.cameraView.switchCamera()
            })
            .disposed(by: disposeBag)
        
        output.showSettingCameraTrigger
            .drive()
            .disposed(by: disposeBag)
        
        
        // ViewModel
        
        viewModel.isMute
            .asDriver()
            .drive( onNext: { [weak self] isEnable in
                self?.muteButton.setImage( isEnable ? .ic_mute_enable : .ic_mute, for: .normal)
            })
            .disposed(by: disposeBag)
        
        viewModel.isSpeaker
            .asDriver()
            .drive( onNext: { [weak self] isEnable in
                guard let self = self else {
                    return
                }
                self.speakerButton.setImage( isEnable ? .ic_speaker_enable : .ic_speaker, for: .normal)
                self.previewVideoView.volume = isEnable ? self.volumnEnable : self.volumn
            })
            .disposed(by: disposeBag)
        
        viewModel.isMicro
            .asDriver()
            .drive( onNext: { [weak self] isEnable in
                self?.microVideoCallButton.setImage( isEnable ? .ic_micro_enable : .ic_micro, for: .normal)
            })
            .disposed(by: disposeBag)
        
    }
    
    //MARK: Objc func
    @objc func handlePanCameraView(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let newCenter = CGPoint(x: cameraView.center.x + translation.x, y: cameraView.center.y + translation.y)
        if gesture.state == .changed {
            cameraView.center = newCameraViewPosition(center: newCenter)

            gesture.setTranslation(.zero, in: view)
        } else if gesture.state == .ended {
            UIView.animate(withDuration: 0.3) {
                self.cameraView.center = self.newEndCameraPosition(center: newCenter)
            }
        }
    }
}

//MARK: - Extension
extension SantaCallViewController {
    
    private func updateCallType(callType: SantaCallType) {
        videoCallButtonView.isHidden = (callType == .videoCall) ? false : true
        audioCallButtonView.isHidden = (callType == .audioCall) ? false : true
        
        refuseAndAcceptView.isHidden = (callType == .incomingAudio || callType == .incomingVideo) ? false : true
        incomingCallView.isHidden = (callType != .videoCall) ? false : true
        
        incomingCallView.setImageIncoming(image: callType.image)
        statusLabel.text = callType.statusLabelIncoming
        
        previewVideoView.setHiddenVideoPlayer(isHidden: callType != .videoCall)
        // Animation
        animateShowVideoCall(isShow: callType == .videoCall)
        
        if callType == .videoCall {
            setupCameraView()
        }
        
    }
    
    private func animateShowVideoCall(isShow: Bool) {
        
        let transformStantaClause = CGAffineTransform(translationX: 0, y: -55) // constaint top 68 -> to 13
        let transformVideoCallButtonView = CGAffineTransform(translationX: 0, y: 120) // height is 120
        
        if isShow {
            UIView.animate(withDuration: 0.2) {
                self.statusCallingView.transform = transformStantaClause
                self.videoCallButtonView.transform = .identity
                self.santaClausLabel.font = UIFont.helveticaNeue_bold(ofSize: 25)
            }
        } else {
            statusCallingView.transform = .identity
            videoCallButtonView.transform = transformVideoCallButtonView
            self.santaClausLabel.font = UIFont.helveticaNeue_bold(ofSize: 39)
        }
    }
    
    func newCameraViewPosition(center: CGPoint) -> CGPoint {
        let maxX = center.x + cameraViewSize.width / 2
        let minX = center.x - cameraViewSize.width / 2
        let maxY = center.y + cameraViewSize.height / 2
        let minY = center.y - cameraViewSize.height / 2
        
        let maxXFrame = view.frame.width - spacingSuperView // 25 is space to leading traling
        let maxYFrame = view.frame.height - spaceBottom// 120 is height of call video button view, 17 is space
        let minXFrame = spacingSuperView
        let minYFrame = spaceTop
        var centerX = center.x
        var centerY = center.y
        if minX < minXFrame {
            centerX = minXFrame + cameraViewSize.width / 2
        }
        if minY < minYFrame {
            centerY = minYFrame + cameraViewSize.height / 2
        }
        if maxX > maxXFrame {
            centerX = maxXFrame - cameraViewSize.width / 2
        }
        if maxY > maxYFrame {
            centerY = maxYFrame - cameraViewSize.height / 2
        }
        
        return CGPoint(x: centerX, y: centerY)
    }
    
    private func newEndCameraPosition(center: CGPoint) -> CGPoint {
        
        let maxXFrame = view.frame.width - spacingSuperView // 25 is space to leading traling
        let maxYFrame = view.frame.height - spaceBottom// 120 is height of call video button view, 17 is space
        let minYFrame = spaceTop
        var centerX = maxXFrame - cameraViewSize.width / 2
        var centerY = center.y
        if center.y < maxYFrame / 2 {
            centerY = minYFrame + cameraViewSize.height / 2 + statusCallingView.frame.height + 20
        } else {
            centerY = maxYFrame - cameraViewSize.height / 2
        }
        return CGPoint(x: centerX, y: centerY)
    }
}
