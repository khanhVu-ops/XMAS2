//
//  VideoNoteNavigator.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 12/10/2023.
//

import Foundation
import UIKit
import RxSwift

protocol FrameMergeNavigatorType {
    func back()
    func showAlertSettingPhotos()
    func show(imagePicker: UIImagePickerController)
    func showAlert() -> Observable<Void>
}

struct FrameMergeNavigator: FrameMergeNavigatorType {
    
    let navigationController : UINavigationController
    
    func back() {
        navigationController.popViewController(animated: true)
    }
    
    func showAlertSettingPhotos() {
        navigationController.showAlertSetting(title: "App", message: "Allow access Photo to choose image!")
    }
    
    func show(imagePicker: UIImagePickerController) {
        navigationController.present(imagePicker, animated: true)
    }
    
    func showAlert() -> Observable<Void> {
        return Observable.create { observer in
            navigationController.showAlert(title: "Alert!", message: "Do you want to save the image to the library?") {
                observer.onNext(())
                observer.onCompleted()
            }
            return Disposables.create()
        }
        
    }
}
