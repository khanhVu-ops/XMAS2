//
//  VideoNoteViewModel.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 12/10/2023.
//

import Foundation
import RxSwift
import RxCocoa

class FrameMergeViewModel {
    var usecase: FrameMergeUseCase
    var navigator: FrameMergeNavigator
    private let errorTracker = ErrorTracker()
    private let loading = ActivityIndicator()
    
    let imagePicker = ImagePickerManager()
    var imagePicked = PublishSubject<UIImage>()
    var imageOverlay = PublishSubject<UIImage>()
    private var combinedObservable: Observable<(UIImage, UIImage)> {
            return Observable.combineLatest(imagePicked, imageOverlay)
        }
    init(navigator: FrameMergeNavigator, service: FrameMergeUseCase) {
        self.usecase = service
        self.navigator = navigator
    }
    
    func transform(_ input: Input) -> Output {
    
        let loadTrigger = input.loadTrigger
            .flatMapLatest { [weak self] _ -> Driver<String> in
                guard let self = self else {
                    return .empty()
                }
                
                return Driver.just(self.usecase.frameURL)
            }
            .do( onNext: { url in
                let imv = UIImageView()
                imv.setImage(url, nil ) {
                    self.imageOverlay.onNext(imv.image!)
                }
            })
        
        let backTrigger = input.backTrigger
            .do ( onNext: { [weak self] in
                self?.navigator.back()
            })
        
        let cameraTrigger = input.cameraTrigger
            .do( onNext: { [weak self] in
                self?.imagePicker.showCamera()
            })
                
        let chooseimageTrigger = input.chooseImageTrigger
            .do( onNext: { [weak self] in
                self?.imagePicker.showLibrary()
            })
             

        let markTrigger = input.markTrigger
                .flatMapLatest { _ in
                    return self.navigator.showAlert()
                        .asDriverComplete()
                }
                .withLatestFrom(combinedObservable.asDriverComplete())
                .flatMapLatest({ [weak self] (pickedImage, overlayImage) -> Driver<UIImage?> in
                    guard let self = self else {
                        return .empty()
                    }
                    return Driver.just(self.usecase.mergeImages(backgroundImage: pickedImage, overlayImage: overlayImage))
                })
                
            
        let isShowMark = combinedObservable
                .map { _ in
                    return false
                }
                            
        imagePicker.onShowAlertSetting = { [weak self] in
            if UserDefaults.hasBeenShowNoticeAccessPhoto {
                self?.navigator.showAlertSettingPhotos()
            } else {
                UserDefaults.hasBeenShowNoticeAccessPhoto = true
            }
        }
        
        imagePicker.onPresentImagePicker = { [weak self] imagePicker in
            self?.navigator.show(imagePicker: imagePicker)
        }
        
        
        imagePicker.onPickedImage = { [weak self] image in
            self?.imagePicked.onNext(image)
        }
        
        return Output(error: errorTracker,
                      loading: loading,
                      loadTrigger: loadTrigger,
                      backTrigger: backTrigger,
                      cameraTrigger: cameraTrigger,
                      chooseImageTrigger: chooseimageTrigger,
                      markTrigger: markTrigger,
                      isShowMark: isShowMark)
    }
    
}

extension FrameMergeViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let backTrigger: Driver<Void>
        let cameraTrigger: Driver<Void>
        let chooseImageTrigger: Driver<Void>
        let markTrigger: Driver<Void>
    }
    
    struct Output {
        let error: ErrorTracker
        let loading: ActivityIndicator
        
        let loadTrigger: Driver<String>
        let backTrigger: Driver<Void>
        let cameraTrigger: Driver<Void>
        let chooseImageTrigger: Driver<Void>
        let markTrigger: Driver<UIImage?>
        
        let isShowMark: Observable<Bool>
    }
}

extension FrameMergeViewModel {
    func saveImage(image: UIImage) -> Driver<Void> {
        return usecase.saveImageToLibrary(image: image)
            .trackError(errorTracker)
            .trackActivity(loading)
            .asDriverComplete()
    }
}
