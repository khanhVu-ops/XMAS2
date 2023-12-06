//
//  UILabel+Extension.swift
//  BaseRxswift_MVVM
//
//  Created by Khanh Vu on 27/09/2023.
//

import Foundation
import UIKit

extension UILabel {
    func setPadding(_ padding: UIEdgeInsets) {
            let textRect = self.textRect(forBounds: self.bounds, limitedToNumberOfLines: self.numberOfLines)
            let paddedRect = textRect.inset(by: padding)
            self.frame = paddedRect
    }
}
