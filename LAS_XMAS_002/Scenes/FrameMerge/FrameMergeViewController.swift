//
//  VideoNoteViewController.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 12/10/2023.
//

import UIKit
import RxSwift
import RxCocoa

class FrameMergeViewController: BaseViewController {

    //MARK: - Outlet
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var markButton: UIButton!
    @IBOutlet weak var frameImageView: UIImageView!
    @IBOutlet weak var chooseImageView: UIImageView!
    
    //MARK: - Property
    var viewModel: FrameMergeViewModel
    let disposeBag = DisposeBag()
    
    //MARK: - Life Cycle
    init(viewModel: FrameMergeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        bindViewModel()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    //MARK: - Private
    private func setUpUI() {
        chooseImageButton.setLayout(radius: 24, borderWidth: 1, borderColor: .colorRed)
        chooseImageButton.setTitleColor(.white, for: .normal)
        chooseImageButton.backgroundColor = .colorRed
        
        cameraButton.setLayout(radius: 24, borderWidth: 1, borderColor: .colorRed)
        cameraButton.backgroundColor = .clear
        cameraButton.setTitleColor(.red, for: .normal)
        
        markButton.isHidden = true
    }
    
    private func bindViewModel() {
        let input = FrameMergeViewModel.Input(loadTrigger: Driver.just(()),
                                              backTrigger: backButton.rx.impactTap.asDriver(),
                                              cameraTrigger: cameraButton.rx.impactTap.asDriver(),
                                              chooseImageTrigger: chooseImageButton.rx.impactTap.asDriver(),
                                              markTrigger: markButton.rx.impactTap.asDriver())
        
        let output = viewModel.transform(input)
        
        output.error.asDriver()
            .drive(onNext: { error in
                if let appError = error as? AppError {
                    Toast.show(appError.message)
                } else {
                    Toast.show(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
        
        output.loading.asObservable()
            .bind(to: ActivityIndicatorUtility().rx_progresshud_animating)
            .disposed(by: disposeBag)
        
        output.loadTrigger
            .drive( onNext: { [weak self] url in
                self?.frameImageView.setImage(url, nil) {
                    if let image = self?.frameImageView.image {
                        asynAfter(1) {
                            self?.viewModel.imageOverlay.onNext(image)

                        }
                    }
                }
            })
            .disposed(by: disposeBag)
        
        output.backTrigger
            .drive()
            .disposed(by: disposeBag)
        
        output.cameraTrigger
            .drive()
            .disposed(by: disposeBag)
        
        output.chooseImageTrigger
            .drive()
            .disposed(by: disposeBag)
        
        output.markTrigger
            .drive( onNext: { [weak self] image in
                guard let image = image else {
                    return
                }
                self?.saveImage(image)
            })
            .disposed(by: disposeBag)
        
        output.isShowMark
            .bind(to: markButton.rx.isHidden)
            .disposed(by: disposeBag)
            
        
        viewModel.imagePicked
            .asDriverComplete()
            .drive( onNext: { [weak self] image in
                self?.chooseImageView.image = image
            })
            .disposed(by: disposeBag)
        viewModel.imagePicked
            .debug()
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel.imageOverlay
            .debug()
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func saveImage(_ image: UIImage) {
        viewModel.saveImage(image: image)
            .drive( onNext: {
                Toast.show("Save successfully!")
            })
            .disposed(by: disposeBag)
    }
}
