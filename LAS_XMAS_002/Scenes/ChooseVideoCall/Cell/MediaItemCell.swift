//
//  MediaItemCell.swift
//  LAS_XMAS_002
//
//  Created by Khanh Vu on 11/11/2023.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie

class MediaItemCell: UICollectionViewCell {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconMark: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    
    var viewModel: ChooseVideoCallViewModel?
    var disposeBag = DisposeBag()
    var urlStr: String?
    var isPlay: Bool = false {
        didSet {
            setState(isPlay: isPlay)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }

    private func setupUI() {
        borderView.setLayout(radius: 20, borderWidth: 1, borderColor: .white)
        
        setShadow(offset: CGSize(width: 2, height: 2), radius: 5, color: .black, opacity: 0.5)
        layer.cornerRadius = 20
    }
    
    func configure(item: MediaModel) {
        iconMark.image = item.url == UserDefaults.videoCallURL ? .ic_mark_enable : .ic_mark
        isPlay = item.isPlay ?? false
//        playButton.setImage(item.isPlay == true ? .ic_pause : .ic_play, for: .normal)
        urlStr = item.url
        titleLabel.text = item.name
        playButton.alpha = 0.0
        thumbImageView.setImage(item.thumbnail ?? "", nil) { [weak self] in
            self?.playButton.alpha = 1.0
        }

    }
    
    func setState(isPlay: Bool) {
        playButton.setImage(isPlay ? .ic_pause : .ic_play, for: .normal)
    }
}
