//
//  HomeItemCell.swift
//  LAS_XMAS_002
//
//  Created by Khanh Vu on 09/11/2023.
//

import UIKit

class HomeItemCell: UICollectionViewCell {

    @IBOutlet weak var contentImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(item: HomeCase) {
        contentImageView.image = item.image()
    }

}
