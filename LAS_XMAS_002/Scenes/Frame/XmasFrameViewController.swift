//
//  VideoNoteViewController.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 12/10/2023.
//

import UIKit
import RxSwift
import RxCocoa

class XmasFrameViewController: BaseViewController {

    //MARK: - Outlet
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var frameCollectionView: UICollectionView!
    
    //MARK: - Property
    var viewModel: XmasFrameViewModel
    let disposeBag = DisposeBag()
    
    let column: CGFloat = UIDevice.current.is_iPhone ? 2 : 5
    let padding: CGFloat = UIDevice.current.is_iPhone ? 32 : 50
    let spacing: CGFloat = UIDevice.current.is_iPhone ? 40 : 65
    
    //MARK: - Life Cycle
    
    init(viewModel: XmasFrameViewModel) {
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
        frameCollectionView.register(FrameItemCell.nibClass, forCellWithReuseIdentifier: FrameItemCell.cellId)
        frameCollectionView.register(AdItemCell.nibClass, forCellWithReuseIdentifier: AdItemCell.cellId)
        frameCollectionView.delegate = self
        frameCollectionView.dataSource = self
    }
    
    private func bindViewModel() {
        let input = XmasFrameViewModel.Input(loadTrigger: Driver.just(()),
                                             backTrigger: backButton.rx.impactTap.asDriver(),
                                             itemSelected: frameCollectionView.rx.itemSelected.asDriver())
        
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
            .drive()
            .disposed(by: disposeBag)
        
        viewModel.listFrames
            .asDriver()
            .drive( onNext: { [weak self] item in
                self?.frameCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Extension UICollectionView
extension XmasFrameViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : viewModel.listFrames.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdItemCell.cellId, for: indexPath) as! AdItemCell
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FrameItemCell.cellId, for: indexPath) as! FrameItemCell
        let element = viewModel.listFrames.value[indexPath.row]
        
        cell.configure(item: element.url)
        return cell
        
    }
}

extension XmasFrameViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 15, left: padding, bottom: 30, right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width, height: 80)
        }
        
        let width = (collectionView.frame.width - 2 * spacing - (column - 1) * spacing) / column
        let height = width * 4 / 3
        return CGSize(width: width, height: height)
    }
}
