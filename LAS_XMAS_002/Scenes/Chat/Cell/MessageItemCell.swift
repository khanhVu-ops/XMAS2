//
//  MessageItemCell.swift
//  LAS_XMAS_002
//
//  Created by Khanh Vu on 15/11/2023.
//

import UIKit

class MessageItemCell: UITableViewCell {

    @IBOutlet weak var avataImageView: UIImageView!
    @IBOutlet weak var contentMessageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        
//        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
        UIView.performWithoutAnimation {
            messageLabel.textColor = .white
            contentMessageView.backgroundColor = .colorRed
            contentMessageView.layer.cornerRadius = 20
            contentMessageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
        
        
    }
    
    
    func configure(item: MessageModel) {
        messageLabel.text = item.message
        setupUI()
    }
}
