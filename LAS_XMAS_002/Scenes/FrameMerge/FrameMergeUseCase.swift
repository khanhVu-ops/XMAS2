//
//  VideoNoteUseCase.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 12/10/2023.
//

import Foundation
import RxSwift
import RxCocoa
import Photos


protocol FrameMergeUseCaseType {
    func mergeImages(backgroundImage: UIImage, overlayImage: UIImage) -> UIImage?
}

struct FrameMergeUseCase: FrameMergeUseCaseType {
    let frameURL: String
    
    func mergeImages(backgroundImage: UIImage, overlayImage: UIImage) -> UIImage? {
        let size = overlayImage.size
        
        //start draw
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let newBgrImage = scaleImageAspectFill(backgroundImage, toSize: size)
        
        // draw bgr
        newBgrImage.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        // draw frame
        overlayImage.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        // export
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // end
        UIGraphicsEndImageContext()
        
        return mergedImage
    }
    
    func scaleImageAspectFill(_ image: UIImage, toSize newSize: CGSize) -> UIImage {
        let aspectWidth = newSize.width / image.size.width
        let aspectHeight = newSize.height / image.size.height
        let aspectRatio = max(aspectWidth, aspectHeight)

        let scaledWidth = image.size.width * aspectRatio
        let scaledHeight = image.size.height * aspectRatio

        let originX = (newSize.width - scaledWidth) / 2.0
        let originY = (newSize.height - scaledHeight) / 2.0

        let aspectFillRect = CGRect(x: originX, y: originY, width: scaledWidth, height: scaledHeight)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: aspectFillRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let scaledImage = scaledImage {
            return scaledImage
        } else {
            return image
        }
    }

    func saveImageToLibrary(image: UIImage) -> Observable<Void> {
        return Observable.create { observer in
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                request.creationDate = Date()
            }, completionHandler: { success, error in
                if success {
                    observer.onNext(())
                    observer.onCompleted()
                } else if let error = error {
                    observer.onError(error)
                }
            })
            
            return Disposables.create()
        }
    }
}
