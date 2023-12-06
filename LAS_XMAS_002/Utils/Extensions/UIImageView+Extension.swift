//
//  Extension+UIImageView.swift
//  BaseRxswift_MVVM
//
//  Created by Khanh Vu on 27/09/2023.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    func setImage(_ urlStr: String, _ placeholder: UIImage?, completion: (() -> Void)? = nil) {
        guard let url = URL(string: urlStr) else {
            return
        }
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with: url, placeholderImage: placeholder) { _, _, _, _ in
            completion?()
        }
    }
    
    func setImage(_ url: URL, _ placeholder: UIImage?, completion: (() -> Void)? = nil) {
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with: url, placeholderImage: placeholder) { _, _, _, _ in
            completion?()
        }
    }
}
