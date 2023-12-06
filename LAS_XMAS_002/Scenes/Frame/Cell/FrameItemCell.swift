//
//  FrameItemCell.swift
//  LAS_XMAS_002
//
//  Created by Khanh Vu on 13/11/2023.
//

import UIKit

class FrameItemCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        imageView.backgroundColor = .lightGray
    }

    func configure(item: String) {
        imageView.setImage(item, nil)
    }
}
