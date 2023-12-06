//
//  VideoNoteViewController.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 12/10/2023.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController {

    //MARK: - Outlet
    @IBOutlet weak var contentCollectionView: UICollectionView!
    
    //MARK: - Property
    let disposeBag = DisposeBag()
    var viewModel: HomeViewModel
    let padding: CGFloat = UIDevice.current.is_iPhone ? 26 : 100
    let spacingCell: CGFloat = UIDevice.current.is_iPhone ? 15 : 50
    let spacingRow: CGFloat = UIDevice.current.is_iPhone ? 26: 100
    //MARK: - Life Cycle
    
    init(viewModel: HomeViewModel) {
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

    //MARK: - Private
    private func setUpUI() {
        contentCollectionView.register(HomeItemCell.nibClass, forCellWithReuseIdentifier: HomeItemCell.cellId)
    }
    
    private func bindViewModel() {
        let input = HomeViewModel.Input(loadTrigger: Driver.just(()),
                                        selectItem: contentCollectionView.rx.itemSelected.asDriver())
        
        let output = viewModel.transform(input)
        
        output.selectItem
            .drive()
            .disposed(by: disposeBag)
        
        viewModel.data
            .bind(to: contentCollectionView.rx.items(cellIdentifier: HomeItemCell.cellId, cellType: HomeItemCell.self)) { index, element, cell in
            cell.configure(item: element)
        }
        .disposed(by: disposeBag)
        
        contentCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
}

//MARK: - Extensions
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: padding, bottom: 0, right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - padding * 2 - spacingCell) / 2
        let height = (collectionView.frame.height - spacingRow) / 2
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacingCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacingRow
    }
}

