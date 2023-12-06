//
//  GithubService.swift
//  LAS_XMAS_002
//
//  Created by Khanh Vu on 12/11/2023.
//

import Foundation
import RxSwift
import RxCocoa

class GithubService: BaseService {

    enum APIPath: String {
        case frames = "/las-khanhvv/XMAS_002_Data/main/frames.json"
        case videos = "/las-khanhvv/XMAS_002_Data/main/videos.json"
        
        var baseURL: String {
            return "https://raw.githubusercontent.com"
        }
        
        var url: String {
            switch self {
            case .frames:
                return baseURL + APIPath.frames.rawValue
            case .videos:
                return baseURL + APIPath.videos.rawValue
            }
        }
    }
    
    static let shared = GithubService()
    
    private override init() {
        
    }
    

    func getMedias() -> Single<MediaDataModel> {
        return rxRequest(APIPath.videos.url, .get, of: MediaDataModel.self)
    }
    
    func getFrame() -> Single<FrameDataModel> {
        return rxRequest(APIPath.frames.url, .get, of: FrameDataModel.self)
    }
    
//    func testDownload() {
//        let videoURL = "https://example.com/your-video.mp4"
//
//        rxDownloadVideo(url: videoURL, title: "hi")
//            .subscribe(
//                onNext: { event in
//                    if let progressEvent = event as? DownloadProgress {
//                        print("Download progress: \(progressEvent.progress.fractionCompleted * 100)%")
//                    } else if let completeEvent = event as? DownloadComplete {
//                        print("Video downloaded successfully at: \(completeEvent.url)")
//                        // Perform any additional actions with the downloaded video URL
//                    }
//                },
//                onError: { error in
//                    print("Error downloading video: \(error)")
//                }
//            )
//            .disposed(by: disposeBag)
//
//    }
}
