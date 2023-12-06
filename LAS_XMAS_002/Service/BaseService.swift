//
//  BaseService.swift
//  LAS_XMAS_002
//
//  Created by Khanh Vu on 12/11/2023.
//

import Foundation
import Alamofire
import RxSwift

// Can use Reachability to notification when change status network

class BaseService {
    var isReachable: Bool {
        return NetworkReachabilityManager.default!.isReachable
    }
    
    // can save base url to remote config firebase
    private let baseURL = "https://raw.githubusercontent.com/" // Github
    
    private var headers: HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: "application/x-www-form-urlencoded")
        
        // if need access token
//        header.add(name: "Authorization", value: "Bearer \(accessToken)")
        return headers
    }
    
    private var alamofireManager: Alamofire.Session
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        alamofireManager = Alamofire.Session(configuration: configuration)
    }
    
    func request<T: Decodable>(_ path: String,
                               _ method: HTTPMethod,
                               parameters: Parameters? = nil,
                               of: T.Type,
                               encoding: ParameterEncoding = URLEncoding.default,
                               success: @escaping (T) -> Void,
                               failure: @escaping (_ code: Int, _ message: String) -> Void) {
        
        if !isReachable {
            failure(1, "Network unavailable!")
            return
        }
        let url = path.starts(with: "http") ? path : "\(baseURL)\(path)"
        
        alamofireManager.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case let .success(data):
                    success(data)
                case let .failure(error):
                    print(error.localizedDescription)
                    let code = error.responseCode ?? 0
                    let message = error.localizedDescription
                    failure(code, message)
                }
            }
    }
    
    func downloadVideo(from url: String,
                       title: String,
                       success: @escaping (URL?) -> Void,
                       failure: @escaping (_ code: Int, _ message: String) -> Void,
                       progressHandler: @escaping (Progress) -> Void) {
        guard let videoURL = URL(string: url) else {
            failure(0, "Invalid URL")
            return
        }

        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("\(title).mp4")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        AF.download(videoURL, to: destination)
            .downloadProgress { progress in
                progressHandler(progress)
            }
            .response { response in
                switch response.result {
                case .success(let url):
                    success(url)
                case .failure(let error):
                    failure(1, error.localizedDescription)
                }
            }
    }

}

extension BaseService {
    func rxRequest<T: Decodable>(_ path: String,
                                 _ method: HTTPMethod,
                                 parameters: Parameters? = nil,
                                 of: T.Type,
                                 encoding: ParameterEncoding = URLEncoding.default) -> Single<T> {
        Single<T>.create { single in
            self.request(path, method, parameters: parameters, of: of, encoding: encoding, success: { data in
                single(.success(data))
            }, failure: { code, message in
                single(.failure(AppError(code: code, message: message)))
            })
            
            return Disposables.create()
        }
    }
    
    
    func rxDownloadVideo(url: String, title: String) -> Observable<DownloadProgress> {
        return Observable.create { observer in
            self.downloadVideo(from: url, title: title) { url in
                if let url = url {
                    observer.onNext(DownloadComplete(url: url))
                    observer.onCompleted()

                } else {
                    observer.onError(AppError(code: 0, message: "URL not Found!"))
                }
            } failure: { code, message in
                observer.onError(AppError(code: code, message: message))
            } progressHandler: { progress in
                observer.onNext(DownloadProgress(progress: progress))
            }
            return Disposables.create()
        }
    }

}


// Define a sealed class to represent download progress and completion
class DownloadProgress {
    let progress: Progress

    init(progress: Progress) {
        self.progress = progress
    }
}

class DownloadComplete: DownloadProgress {
    let url: URL

    init(url: URL) {
        self.url = url
        super.init(progress: Progress(totalUnitCount: 1)) // Set a dummy progress for completeness
    }
}
