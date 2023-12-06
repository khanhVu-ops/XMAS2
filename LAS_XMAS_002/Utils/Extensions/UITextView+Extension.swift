//
//  UITextView+Extension.swift
//  LAS_XMAS_002
//
//  Created by Khanh Vu on 15/11/2023.
//

import Foundation
import UIKit

extension UITextView {
    func getSize() -> CGSize {
        let fixedWidth = self.frame.size.width
        let newSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        return newSize
    }
}
