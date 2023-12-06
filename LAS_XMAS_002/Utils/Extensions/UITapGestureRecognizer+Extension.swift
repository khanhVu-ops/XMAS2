//
//  UITapGestureRecognizer+Extension.swift
//  BaseRxswift_MVVM
//
//  Created by Khanh Vu on 02/10/2023.
//

import Foundation
import UIKit


// Use
//let termRange = (text as NSString).range(of: "Điều khoản sử dụng")
//let privacyRange = (text as NSString).range(of: "Chính sách quyền riêng tư")
//
//if gesture.tapOnRange(termRange, ofLabel: termAndPrivacyLabel) {
//    coordinator.toWeb(.terms)
//    return
//}
//
//if gesture.tapOnRange(privacyRange, ofLabel: termAndPrivacyLabel) {
//    coordinator.toWeb(.privacy)
//    return
//}
extension UITapGestureRecognizer {
    
    func tapOnRange(_ range: NSRange, ofLabel label: UILabel) -> Bool {
        guard let attrString = label.attributedText else {
            return false
        }

        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: attrString)

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        let locationOfTouchInLabel = self.location(in: label)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x, y: locationOfTouchInLabel.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer,
                                                            in: textContainer,
                                                            fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, range)
    }
}
