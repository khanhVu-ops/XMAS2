//
//  VideoNoteViewController.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 12/10/2023.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class ChooseVideoCallViewController: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var mediaCollectionView: UICollectionView!
    
    //MARK: - Property
    var viewModel: ChooseVideoCallViewModel
    let disposeBag = DisposeBag()
    
    let padding: CGFloat = UIDevice.current.is_iPhone ? 25 : 60
    let spacing: CGFloat = UIDevice.current.is_iPhone ? 15: 40
    let column: CGFloat = UIDevice.current.is_iPhone ? 2 : 4
    
    //MARK: - Life Cycle
    
    init(viewModel: ChooseVideoCallViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        SDImageCache.shared.clearMemory()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        reloadData()
    }

    //MARK: - Private
    private func setUpUI() {
        mediaCollectionView.register(MediaItemCell.nibClass, forCellWithReuseIdentifier: MediaItemCell.cellId)
        mediaCollectionView.register(AdItemCell.nibClass, forCellWithReuseIdentifier: AdItemCell.cellId)
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
    }
    
    private func bindViewModel() {
        let input = ChooseVideoCallViewModel.Input(loadTrigger: rx.viewWillAppear.asDriver(),
                                                   backTrigger: backButton.rx.impactTap.asDriver(),
                                                   itemSelected: mediaCollectionView.rx.itemSelected.asDriver())
        
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
            .drive()
            .disposed(by: disposeBag)
        
        output.backTrigger
            .drive()
            .disposed(by: disposeBag)
        
        output.itemSelected
            .drive( onNext: { [weak self] item in
                self?.showBottomSheet(item: item)
            })
            .disposed(by: disposeBag)
        
        viewModel.data.asDriver()
            .drive( onNext: { [weak self] _ in
                self?.mediaCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
       
    }
    
    func showBottomSheet(item: MediaModel) {
        let alertController = UIAlertController(title: "Choose Duration", message: nil, preferredStyle: .actionSheet)
        let scheduleValue: [Int] = [3, 5, 10, 30, 60, 180, 300, 600, 1800]
        
        let second3s = UIAlertAction(title: "After 3 seconds", style: .default) { _ in
            UserDefaults.schedule = scheduleValue[0]
            self.setVideoCall(item: item)
        }
        let second5s = UIAlertAction(title: "After 5 seconds", style: .default) { _ in
            UserDefaults.schedule = scheduleValue[1]
            self.setVideoCall(item: item)
        }
        let second10s = UIAlertAction(title: "After 10 seconds", style: .default) { _ in
            UserDefaults.schedule = scheduleValue[2]
            self.setVideoCall(item: item)
        }
        let second30s = UIAlertAction(title: "After 30 seconds", style: .default) { _ in
            UserDefaults.schedule = scheduleValue[3]
            self.setVideoCall(item: item)
        }
        let minute1p = UIAlertAction(title: "After 1 Minute", style: .default) { _ in
            UserDefaults.schedule = scheduleValue[4]
            self.setVideoCall(item: item)
        }
        let minute3p = UIAlertAction(title: "After 3 Minute", style: .default) { _ in
            UserDefaults.schedule = scheduleValue[5]
            self.setVideoCall(item: item)
        }
        let minute5p = UIAlertAction(title: "After 5 Minute", style: .default) { _ in
            UserDefaults.schedule = scheduleValue[6]
            self.setVideoCall(item: item)
        }
        let minute10p = UIAlertAction(title: "After 10 Minute", style: .default) { _ in
            UserDefaults.schedule = scheduleValue[7]
            self.setVideoCall(item: item)
        }
        let minute30p = UIAlertAction(title: "After 30 Minute", style: .default) { _ in
            UserDefaults.schedule = scheduleValue[8]
            self.setVideoCall(item: item)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let actions: [UIAlertAction] = [second3s, second5s, second10s, second30s, minute1p, minute3p, minute5p, minute10p, minute30p]
        
        for action in actions {
            alertController.addAction(action)
        }
        alertController.addAction(cancelAction)
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view // Set the view that will anchor the action sheet
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // Set the anchor point
            popoverController.permittedArrowDirections = [] // Remove arrow pointing to the source view
        }
        present(alertController, animated: true, completion: nil)
    }
    
    func setVideoCall(item: MediaModel) {
        UserDefaults.videoCallURL = item.url
        switch viewModel.usecase.callType {
        case .video:
            CallService.shared.openVideoCall()
        case .audio:
            CallService.shared.openAudioCall()
        }
        reloadData()
    }
    
    func handlePreviewVideo(item: MediaModel) {
        self.viewModel.handlePlayTrigger(item: item)
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.mediaCollectionView.reloadData()
        }
    }
}

//MARK: - Extension UICollectionView
extension ChooseVideoCallViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : viewModel.data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdItemCell.cellId, for: indexPath) as! AdItemCell
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaItemCell.cellId, for: indexPath) as! MediaItemCell
        let element = viewModel.data.value[indexPath.row]
        cell.viewModel = self.viewModel
        cell.configure(item: element)
        cell.playButton.rx.impactTap
            .asDriver()
            .drive( onNext: { [weak cell] in
                if cell?.isPlay == true {
                    self.viewModel.audioPlayer?.pause()
                    cell?.isPlay = false
                    
                } else {
                    self.handlePreviewVideo(item: element)
                }
                
            })
            .disposed(by: cell.disposeBag)
        return cell
        
    }
}

extension ChooseVideoCallViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10, left: padding, bottom: 40, right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width, height: 80)
        }
        
        let width = ( collectionView.frame.width - padding * 2 - spacing * (column - 1) ) / column
        let height = width * 3 / 2
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
}
