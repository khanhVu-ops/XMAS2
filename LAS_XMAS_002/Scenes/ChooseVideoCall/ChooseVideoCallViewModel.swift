//
//  VideoNoteViewModel.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 12/10/2023.
//

import Foundation
import RxSwift
import RxCocoa
import AVFoundation

class ChooseVideoCallViewModel {
    var usecase: ChooseVideoCallUseCase
    var navigator: ChooseVideoCallNavigator
    private let errorTracker = ErrorTracker()
    private let loading = ActivityIndicator()
    
    var data = BehaviorRelay<[MediaModel]>(value: [])
    var audioPlayer: AVPlayer?
    
    init(navigator: ChooseVideoCallNavigator, service: ChooseVideoCallUseCase) {
        self.usecase = service
        self.navigator = navigator
    }
    
    func transform(_ input: Input) -> Output {
        let loadTrigger = input.loadTrigger
            .flatMapLatest { [weak self] _ -> Driver<MediaDataModel> in
                guard let self = self else {
                    return .empty()
                }
                return self.usecase.getMedias()
                    .trackActivity(loading)
                    .trackError(errorTracker)
                    .asDriverComplete()
            }
            .do ( onNext: { [weak self] value in
                self?.data.accept(value.data)
            })
            .mapToVoid()
                
        let backTrigger = input.backTrigger
            .do ( onNext: { [weak self] in
                self?.navigator.back()
            })
                
        let itemSelected = input.itemSelected
            .withLatestFrom(data.asDriver()) { indexPath, value in
                return value[indexPath.row]
            }
            .flatMapLatest { value in
                return Driver.just(value)
            }
        
        return Output(error: errorTracker,
                      loading: loading,
                      loadTrigger: loadTrigger,
                      backTrigger: backTrigger,
                      itemSelected: itemSelected)
    }
    
}

extension ChooseVideoCallViewModel {
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

        let itemSelected: Driver<MediaModel>
    }
}

extension ChooseVideoCallViewModel {
    func handlePlayTrigger(item: MediaModel) -> Driver<Void> {
        guard let url = URL(string: item.url) else {
            return .empty()
        }
        
        return usecase.setUpAsset(with: url)
            .trackError(errorTracker)
            .trackActivity(loading)
            .asDriverComplete()
            .do( onNext: { [weak self] asset in
                guard let self = self else {
                    return
                }
                switch self.usecase.callType {
                case .video:
                    self.navigator.previewVideo(asset: asset)
                    handleData(item: item)
                case .audio:
                    self.audioPlayer = AVPlayer(playerItem: AVPlayerItem(asset: asset))
                    self.audioPlayer?.play()
                    handleData(item: item)
                }
            })
            .mapToVoid()
    }
    
    func handleData(item: MediaModel) {
        var values = data.value
        for i in 0..<values.count {
            values[i].isPlay = (values[i].id == item.id) ? true : false
        }
        data.accept(values)
    }
}
