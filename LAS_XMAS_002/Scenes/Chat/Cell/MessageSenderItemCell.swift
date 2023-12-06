//
//  MessageSenderItemCell.swift
//  LAS_XMAS_002
//
//  Created by Khanh Vu on 15/11/2023.
//

import UIKit

class MessageSenderItemCell: UITableViewCell {

    @IBOutlet weak var messageView: UIView!
//    @IBOutlet weak var messageLabel: PaddingLabel
    
    @IBOutlet weak var messageTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {

//        messageLabel.paddingRight = 5
        UIView.performWithoutAnimation {
            
            messageView.layer.cornerRadius = 20
            messageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            messageView.backgroundColor = .white
            messageTextView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 5)
        }
    }
    
    func configure(item: MessageModel) {
        messageTextView.text = item.message
        setupUI()
    }
}
