//
//  VideoNoteUseCase.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 12/10/2023.
//

import Foundation
import RxSwift
import RxCocoa
import AVFoundation

enum CallType {
    case video
    case audio
}

protocol ChooseVideoCallUseCaseType {
    func getMedias() -> Single<MediaDataModel>
    func setUpAsset(with url: URL) -> Observable<AVAsset>
    func loadDataAudio(with url: URL) -> Observable<Data>
}

struct ChooseVideoCallUseCase: ChooseVideoCallUseCaseType {
    let callType: CallType
    
    func getMedias() -> Single<MediaDataModel>{
        return GithubService.shared.getMedias()
    }
    
    func setUpAsset(with url: URL) -> Observable<AVAsset> {
        return Observable.create { observer in
            let asset = AVAsset(url: url)
            asset.loadValuesAsynchronously(forKeys: ["playable"]) {
                var error: NSError? = nil
                let status = asset.statusOfValue(forKey: "playable", error: &error)
                switch status {
                case .loaded:
                    observer.onNext(asset)
                    observer.onCompleted()
                case .failed:
                    observer.onError(error!)
                case .cancelled:
                    observer.onError(error!)
                    print(".cancelled")
                default:
                    observer.onError(error!)
                    print("default")
                }
            }
            return Disposables.create()
        }
        
    }
    
    func loadDataAudio(with url: URL) -> Observable<Data> {
        return Observable.create { observer in
            DispatchQueue.global(qos: .background).async {
                do {
                    let data = try Data(contentsOf: url)
//                    let audioPlayer = try AVAudioPlayer(data: data)
                    observer.onNext(data)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
