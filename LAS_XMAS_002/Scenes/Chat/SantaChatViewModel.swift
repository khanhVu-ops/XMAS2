//
//  VideoNoteViewModel.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 12/10/2023.
//

import Foundation
import RxSwift
import RxCocoa

class SantaChatViewModel {
    var usecase: SantaChatUseCase
    var navigator: SantaChatNavigator
    private let errorTracker = ErrorTracker()
    private let loading = ActivityIndicator()
    
    var listMessages = BehaviorRelay<[MessageModel]>(value: [])
//    var sendMessage = PublishSubject<String>()
    var newMessage = BehaviorRelay<String>(value: "Hello")
    init(navigator: SantaChatNavigator, service: SantaChatUseCase) {
        self.usecase = service
        self.navigator = navigator
    }
    
    func transform(_ input: Input) -> Output {
        let scrollToBottomTrigger = input.scrollToBottomTrigger
        
        let backTrigger = input.backTrigger
            .do( onNext: { [weak self] in
                self?.navigator.back()
            })
                
        let loadTrigger = input.loadTrigger
            .withLatestFrom(newMessage.asDriver())
            .flatMapLatest { [weak self] mess -> Driver<MessageModel> in
                guard let self = self else {
                    return .empty()
                }
                return self.usecase.sendMessage(mess)
                    .trackError(errorTracker)
                    .asDriverComplete()
            }
            .do( onNext: { [weak self] receiveMess in
                guard let self = self else {
                    return
                }
                self.addNewMessage(message: receiveMess)
            })
            .mapToVoid()
                
        let sendTrigger = input.sendTrigger
                .withLatestFrom(newMessage.skip(1).asDriverComplete())
                .map { $0.trimSpaceAndNewLine() }
                .filter { !$0.isEmpty }
                .do( onNext: { [weak self] mess in
                    guard let self = self else {
                        return
                    }
                    self.addNewMessage(message: MessageModel(message: mess, isSender: true))
                })
                .flatMapLatest { [weak self] mess -> Driver<MessageModel> in
                    guard let self = self else {
                        return .empty()
                    }
                    
                    return self.usecase.sendMessage(mess)
                        .trackError(errorTracker)
                        .asDriverComplete()
                }
                .do( onNext: { [weak self] receiveMess in
                    guard let self = self else {
                        return
                    }
                    self.addNewMessage(message: receiveMess)
                    
                })
                .mapToVoid()
                    

        
        return Output(error: errorTracker,
                      loading: loading,
                      loadTrigger: loadTrigger,
                      sendTrigger: sendTrigger,
                      backTrigger: backTrigger,
                      scrollToBottomTrigger: scrollToBottomTrigger)
    }
    
}

extension SantaChatViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let sendTrigger: Driver<Void>
        let backTrigger: Driver<Void>
        let scrollToBottomTrigger: Driver<Void>
    }
    
    struct Output {
        let error: ErrorTracker
        let loading: ActivityIndicator
        let loadTrigger: Driver<Void>
        let sendTrigger: Driver<Void>
        let backTrigger: Driver<Void>
        let scrollToBottomTrigger: Driver<Void>
    }
}

extension SantaChatViewModel {
    func addNewMessage(message: MessageModel) {
        var listMess = listMessages.value
//        listMess.reverse()
//        listMess.append(message)
//        listMessages.accept(listMess.reversed())
        listMess.append(message)
        listMessages.accept(listMess)
        
    }
}
