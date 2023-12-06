//
//  VideoNoteViewModel.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 12/10/2023.
//

import Foundation
import RxSwift
import RxCocoa

class XmasFrameViewModel {
    var usecase: XmasFrameUseCase
    var navigator: XmasFrameNavigator
    private let errorTracker = ErrorTracker()
    private let loading = ActivityIndicator()
    
    var listFrames = BehaviorRelay<[FrameModel]>(value: [])
    
    init(navigator: XmasFrameNavigator, service: XmasFrameUseCase) {
        self.usecase = service
        self.navigator = navigator
    }
    
    func transform(_ input: Input) -> Output {
        let loadTrigger = input.loadTrigger
            .flatMapLatest { [weak self] _ -> Driver<FrameDataModel> in
                guard let self = self else {
                    return .empty()
                }
                return self.usecase.getFrames()
                    .trackActivity(loading)
                    .trackError(errorTracker)
                    .asDriverComplete()
            }
            .do (
                onNext: { [weak self] value in
                    guard let self = self else {
                        return
                    }
                    self.listFrames.accept(value.data)
                }
            )
            .mapToVoid()
                
        let backTrigger = input.backTrigger
            .do ( onNext: { [weak self] in
                self?.navigator.back()
            })
        
        let itemSelected = input.itemSelected
                .withLatestFrom(listFrames.asDriver()) { indexPath, listData in
                    return listData[indexPath.row]
                }
                .do ( onNext: { [weak self] value in
                    self?.navigator.goToFrameImage(url: value.url)
                })
                .mapToVoid()
                
       
        
        return Output(error: errorTracker,
                      loading: loading,
                      loadTrigger: loadTrigger,
                      backTrigger: backTrigger,
                      itemSelected: itemSelected)
    }
    
}

extension XmasFrameViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        
        let backTrigger: Driver<Void>
        let itemSelected: Driver<IndexPath>
        
    }
    
    struct Output {
        let error: ErrorTracker
        let loading: ActivityIndicator
        
        let loadTrigger: Driver<Void>
        
        let backTrigger: Driver<Void>
        let itemSelected: Driver<Void>
    }
}
