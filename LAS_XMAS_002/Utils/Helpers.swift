//
//  Utils.swift
//  BaseRxswift_MVVM
//
//  Created by Khanh Vu on 27/09/2023.
//

import Foundation
import UIKit
import AVFoundation
import Photos

class Helper {
    
    class func getThumbnailImage(from videoURL: URL, completion: @escaping((UIImage?, URL) -> Void)) {
        let asset = AVURLAsset(url: videoURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.requestedTimeToleranceAfter = CMTime(value: 1, timescale: 100)
        generator.requestedTimeToleranceBefore = CMTime(value: 1, timescale: 100)
        generator.generateCGImagesAsynchronously(forTimes: [NSValue(time: .zero)]) { _, cgImage, _, _, _ in
            guard let cgImage = cgImage else {
                completion(nil, videoURL)
                return
            }
            completion(UIImage(cgImage: cgImage), videoURL)
        }
    }
    
    class func getThumbnailImage(from videoURL: URL) -> UIImage? {
        let asset = AVURLAsset(url: videoURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.requestedTimeToleranceAfter = CMTime(value: 1, timescale: 100)
        generator.requestedTimeToleranceBefore = CMTime(value: 1, timescale: 100)
        generator.maximumSize = CGSize(width: 150, height: 150)
        var thumbnailImage: UIImage?
//        if
        do {
            let cgImage = try generator.copyCGImage(at: CMTime(value: 1, timescale: 100), actualTime: nil)
            thumbnailImage = UIImage(cgImage: cgImage)
        } catch {
            print("Error generating thumbnail image: \(error.localizedDescription)")
        }
        
        return thumbnailImage
    }
    
    class func createVideoThumbnail(url: String?, completion: @escaping (_ image: UIImage?) -> Void) {
        guard let url = URL(string: url ?? "") else {
            return
            
        }
        DispatchQueue.global().async {
            let request = URLRequest(url: url)
            let cache = URLCache.shared
            
            if let cachedResponse = cache.cachedResponse(for: request),
               let image = UIImage(data: cachedResponse.data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            
            let asset = AVAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            
            var time = asset.duration
            time.value = min(time.value, 2)
            
            var image: UIImage?
            
            do {
                let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
                image = UIImage(cgImage: cgImage)
            } catch {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            
            if let image = image, let data = image.pngData(),
               let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) {
                let cachedResponse = CachedURLResponse(response: response, data: data)
                cache.storeCachedResponse(cachedResponse, for: request)
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    //Permission
    class func requestPermissionAccessPhotos(completion: @escaping(Bool)->Void) {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                completion(true)
            case .denied, .restricted:
                completion(false)
                print("Access to Photos library denied or restricted.")
            case .notDetermined:
                completion(false)
                print("Access to Photos library not determined.")
            case .limited:
                completion(false)
                print("Limit")
            @unknown default:
                completion(false)
                print("Unknown authorization status for Photos library.")
            }
        }
    }
}
