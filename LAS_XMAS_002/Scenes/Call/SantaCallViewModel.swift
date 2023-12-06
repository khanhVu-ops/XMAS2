//
//  VideoNoteViewModel.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 12/10/2023.
//

import Foundation
import RxSwift
import RxCocoa
import AVFAudio

class SantaCallViewModel {
    var usecase: SantaCallUseCase
    var navigator: SantaCallNavigator
    private let errorTracker = ErrorTracker()
    private let loading = ActivityIndicator()
    var callType = BehaviorRelay<SantaCallType>(value: .incomingAudio)
    
    private var audioSession = AVAudioSession.sharedInstance()
    var isSpeaker = BehaviorRelay<Bool>(value: false)
    var isMute = BehaviorRelay<Bool>(value: false)
    var isMicro = BehaviorRelay<Bool>(value: false)
    
    init(navigator: SantaCallNavigator, service: SantaCallUseCase) {
        self.usecase = service
        self.navigator = navigator
    }
    
    func transform(_ input: Input) -> Output {
        let loadTrigger = input.loadTrigger
            .do { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.callType.accept(self.usecase.santaCallType)
            }
        
        let refuseIncomingTrigger = Driver.merge(input.refuseIncomingTrigger,
                                                 input.cancelAudioCallTrigger,
                                                 input.cancelVideoCallTrigger,
                                                 input.callCanceledTrigger)
            .do ( onNext: { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.navigator.refuseIncomingCall()
            })
        
        
        let acceptIncomingTrigger = input.acceptIncomingTrigger
            .flatMapLatest { [weak self] _ -> Driver<URL> in
                guard let self = self else {
                    return .empty()
                }
                return Driver.just(self.usecase.santaCallURL)
            }
            .do ( onNext: {
                [weak self] _ in
                guard let self = self else {
                    return
                }
                if self.callType.value == .incomingAudio {
                    self.callType.accept(.audioCall)
                } else {
                    self.callType.accept(.videoCall)
                }
            })
        
        let muteTrigger = input.muteTrigger
                .do ( onNext: { [weak self] in
                    guard let self = self else {
                        return
                    }
                    var value = self.isMute.value
                    value.toggle()
                    self.isMute.accept(value)
                })

        let speakerTrigger = input.speakerTrigger
                .do ( onNext: { [weak self] in
                    guard let self = self else {
                        return
                    }
                    var value = self.isSpeaker.value
                    value.toggle()
                    self.isSpeaker.accept(value)
                })
        
        let openVideoTrigger = input.openVideoTrigger
                .do ( onNext: { [weak self] in
                    
                    self?.callType.accept(.videoCall)
                })
        
        let microVideoCallTrigger = input.microVideoCallTrigger
            .do( onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                var value = self.isMicro.value
                value.toggle()
                self.isMicro.accept(value)
            })
                
        let rotateCameraTrigger = input.rotateCameraTrigger
        
        let showSettingCameraTrigger = input.showSettingCameraTrigger
            .do( onNext: { [weak self] in
                if UserDefaults.hasBeenShowNoticeAccessCamera == true {
                    self?.navigator.showSettingCamera()
                } else {
                    UserDefaults.hasBeenShowNoticeAccessCamera = true
                }
            })
                    
                    
        return Output(error: errorTracker,
                      loading: loading,
                      loadTrigger: loadTrigger,
                      santaCallType: callType.asDriverOnErrorJustComplete(),
                      refuseIncomingTrigger: refuseIncomingTrigger,
                      acceptIncomingTrigger: acceptIncomingTrigger,
                      muteTrigger: muteTrigger,
                      speakerTrigger: speakerTrigger,
                      openVideoTrigger: openVideoTrigger,
                      microVideoCallTrigger: microVideoCallTrigger,
                      rotateCameraTrigger: rotateCameraTrigger,
                      showSettingCameraTrigger: showSettingCameraTrigger)
    }
    
}

extension SantaCallViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        
        // Incoming button
        let refuseIncomingTrigger: Driver<Void>
        let acceptIncomingTrigger: Driver<Void>
        
        // Audio Button
        let muteTrigger: Driver<Void>
        let speakerTrigger: Driver<Void>
        let openVideoTrigger: Driver<Void>
        let cancelAudioCallTrigger: Driver<Void>
        
        // Video button
        let cancelVideoCallTrigger: Driver<Void>
        let microVideoCallTrigger: Driver<Void>
        let rotateCameraTrigger: Driver<Void>
        
        // Property
        let callCanceledTrigger: Driver<Void>
        let showSettingCameraTrigger: Driver<Void>
    }
    
    struct Output {
        let error: ErrorTracker
        let loading: ActivityIndicator
        
        let loadTrigger: Driver<Void>
        let santaCallType: Driver<SantaCallType>
        
        // Incoming button
        let refuseIncomingTrigger: Driver<Void>
        let acceptIncomingTrigger: Driver<URL>
        
        // Audio Button
        let muteTrigger: Driver<Void>
        let speakerTrigger: Driver<Void>
        let openVideoTrigger: Driver<Void>
        
        // Video button
        let microVideoCallTrigger: Driver<Void>
        let rotateCameraTrigger: Driver<Void>
        
        // Property
        let showSettingCameraTrigger: Driver<Void>

        
    }
}
