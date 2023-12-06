//
//  VideoNoteViewModel.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 12/10/2023.
//

import Foundation
import RxSwift
import RxCocoa

enum HomeCase {
    case videoCall
    case audioCall
    case chatWithSanta
    case xmasFrame
    
    func image() -> UIImage? {
        switch self {
        case .videoCall:
            return .img_video_call
        case .audioCall:
            return .img_audio_call
        case .chatWithSanta:
            return .img_chat_with_santa
        case .xmasFrame:
            return .img_xmas_frame
        }
    }
}

class HomeViewModel {
    var navigator: HomeNavigator
    
    var data = BehaviorRelay<[HomeCase]>(value: [.videoCall, .audioCall, .chatWithSanta, .xmasFrame])
    
    init(navigator: HomeNavigator) {
        self.navigator = navigator
    }
    
    func transform(_ input: Input) -> Output {
        
        let selectItem = input.selectItem
            .withLatestFrom(data.asDriver()) { indexPath, data in
                return data[indexPath.row]
            }
            .do { [weak self] element in
                guard let self = self else {
                    return
                }
                switch element {                    
                case .videoCall:
//                    self.navigator.goToSantaVideoCall()
                    self.navigator.goToChooseVideos()
                case .audioCall:
//                    self.navigator.goToSantaAudioCall()
                    self.navigator.goToChooseAudio()
                case .chatWithSanta:
                    self.navigator.goToSantaChat()
                case .xmasFrame:
                    self.navigator.goToXmasFrame()
                }
            }
            .mapToVoid()
        return Output(selectItem: selectItem)
    }
    
}

extension HomeViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let selectItem: Driver<IndexPath>
    }
    
    struct Output {
        let selectItem: Driver<Void>
    }
}
