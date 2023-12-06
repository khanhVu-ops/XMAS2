//
//  UIView+Extension.swift
//  BaseRxswift_MVVM
//
//  Created by Khanh Vu on 27/09/2023.
//

import Foundation
import UIKit

extension UIView {
    
    class var nibNameClass: String { return String(describing: self.self) }
    
    class var nibClass: UINib? {
        if Bundle.main.path(forResource: nibNameClass, ofType: "nib") != nil {
            return UINib(nibName: nibNameClass, bundle: nil)
        } else {
            return nil
        }
    }
    
    class func loadFromNib(nibName: String? = nil) -> Self? {
        return loadFromNib(nibName: nibName, type: self)
    }
    
    class func loadFromNib<T: UIView>(nibName: String? = nil, type: T.Type) -> T? {
        guard let nibViews = Bundle.main.loadNibNamed(nibName ?? self.nibNameClass, owner: nil, options: nil)
        else { return nil }
        
        return nibViews.filter({ (nibItem) -> Bool in
            return (nibItem as? T) != nil
        }).first as? T
    }
    
    // Set Radius
    func setCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func setCornerTopRadius(radius: CGFloat, borderwidth: CGFloat, borderColor: UIColor) {
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderwidth
        layer.masksToBounds = true
    }
    
    func roundCorners(topLeftRadius: CGFloat, topRightRadius: CGFloat, bottomLeftRadius: CGFloat, bottomRightRadius: CGFloat) {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        
        // Top left corner
        let topLeftPath = UIBezierPath(
            roundedRect: CGRect(x: 0, y: 0, width: bounds.width / 2, height: bounds.height / 2),
            byRoundingCorners: [.topLeft],
            cornerRadii: CGSize(width: topLeftRadius, height: topLeftRadius)
        )
        maskLayer.addSublayer(createMaskLayer(withPath: topLeftPath))
        
        // Top right corner
        let topRightPath = UIBezierPath(
            roundedRect: CGRect(x: bounds.width / 2, y: 0, width: bounds.width / 2, height: bounds.height / 2),
            byRoundingCorners: [.topRight],
            cornerRadii: CGSize(width: topRightRadius, height: topRightRadius)
        )
        maskLayer.addSublayer(createMaskLayer(withPath: topRightPath))
        
        // Bottom left corner
        let bottomLeftPath = UIBezierPath(
            roundedRect: CGRect(x: 0, y: bounds.height / 2, width: bounds.width / 2, height: bounds.height / 2),
            byRoundingCorners: [.bottomLeft],
            cornerRadii: CGSize(width: bottomLeftRadius, height: bottomLeftRadius)
        )
        maskLayer.addSublayer(createMaskLayer(withPath: bottomLeftPath))
        
        // Bottom right corner
        let bottomRightPath = UIBezierPath(
            roundedRect: CGRect(x: bounds.width / 2, y: bounds.height / 2, width: bounds.width / 2, height: bounds.height / 2),
            byRoundingCorners: [.bottomRight],
            cornerRadii: CGSize(width: bottomRightRadius, height: bottomRightRadius)
        )
        maskLayer.addSublayer(createMaskLayer(withPath: bottomRightPath))
        
        layer.mask = maskLayer
    }
    
    private func createMaskLayer(withPath path: UIBezierPath) -> CAShapeLayer {
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        return maskLayer
    }
    
    func setSpecificCornerRadius(corner: CACornerMask, radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = corner
    }
    
    // Set Border
    func setBorder(width: CGFloat, color: UIColor?) {
        layer.borderWidth = width
        layer.borderColor = color?.cgColor
    }
    
    // Set radius with border
    func setLayout(radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor?) {
        layer.cornerRadius = radius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
        layer.masksToBounds = true
    }
    
    // Set Shadow
    func setShadow(offset: CGSize, radius: CGFloat, color: UIColor, opacity: Float) {
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }

    func removeAllSubviews() {
        let allSubs = self.subviews
        for aSub in allSubs {
            aSub.removeFromSuperview()
        }
    }
}
