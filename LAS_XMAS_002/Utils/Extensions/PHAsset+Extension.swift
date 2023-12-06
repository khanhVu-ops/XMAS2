//
//  PHAsset+Extension.swift
//  BaseRxswift_MVVM
//
//  Created by Khanh Vu on 27/09/2023.
//

import Foundation
import Photos
import UIKit

extension PHAsset {
    
    func avAsset(completion: @escaping (AVURLAsset?) -> Void){
        var avAsset: AVURLAsset?
        let options: PHVideoRequestOptions = PHVideoRequestOptions()
        options.version = .original
        PHCachingImageManager().requestAVAsset(forVideo: self, options: nil) { (asset, audioMix, args) in
            avAsset = asset as? AVURLAsset
            completion(avAsset)
        }
    }
    
    func getThumbnailImage(targetSize: CGSize, completion: @escaping (UIImage) -> Void) {
        let imageManager = PHImageManager.default()
        let thumbnailOptions = PHImageRequestOptions()
        thumbnailOptions.deliveryMode = .opportunistic
        thumbnailOptions.resizeMode = .exact
        thumbnailOptions.isNetworkAccessAllowed = false
        thumbnailOptions.isSynchronous = true
        imageManager.requestImage(for: self, targetSize: targetSize, contentMode: .aspectFill, options: thumbnailOptions) { (image, info) in
            guard let image = image else {
                return
            }
            completion(image)
        }
    }
}
