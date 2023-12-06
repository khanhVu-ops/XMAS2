//
//  ImagePickerManager.swift
//  LAS_XMAS_002
//
//  Created by Khanh Vu on 13/11/2023.
//

import Foundation
import UIKit
import Photos

class ImagePickerManager: NSObject {
    
    private lazy var imagePicker = UIImagePickerController()
    
    var onPresentImagePicker: ((UIImagePickerController) -> Void)?
    var onPickedImage: ((UIImage) -> Void)?
    var onCancelImagePicker: (() -> Void)?
    var onShowAlertSetting: (() -> Void)?
    func setImageFromImagePicker(image: UIImage) {}
    
    func actionCancelImagePicker() {}
    
    override init() {
        super.init()
        
    }
    
    func showLibrary() {
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .photoLibrary
        self.onPresentImagePicker?(self.imagePicker)
    }
    
    func showCamera() {
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        onPresentImagePicker?(imagePicker)
    }

    func requestPermissionAccessPhotos(completion: @escaping((Bool) -> Void)) {
        PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    completion(true)
                case .denied, .restricted:
                    completion(false)
                case .notDetermined:
                    self.requestPermissionAccessPhotos(completion: completion)
                default:
                    completion(false)
                    break
                }
            }
    }
}

//MARK: library
extension ImagePickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        guard let image = img else {
            return
        }
        onPickedImage?(image)

        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        onCancelImagePicker?()
    }
}
