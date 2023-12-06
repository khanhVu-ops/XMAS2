//
//  Global+Extension.swift
//  BaseRxswift_MVVM
//
//  Created by Khanh Vu on 27/09/2023.
//


import Foundation
import UIKit

let columns: CGFloat = UIDevice.current.is_iPhone ? 3 : 5
let padding: CGFloat = UIDevice.current.is_iPhone ? 15 : 40


extension UIFont {
    
    static func fontRegular(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "AvenirNextLTPro-Regular", size: size)
    }
    
    static func fontMedium(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "AvenirNextLTPro-Medium", size: size)
    }
    
    static func fontBold(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "AvenirNextLTPro-Bold", size: size)
    }
    
}

extension UICollectionViewCell {
    static var cellId: String {
        return String(describing: self)
    }
}


extension UITableViewCell {
    static var cellId: String {
        return String(describing: self)
    }
}

extension UIDevice {
    var is_iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
}

extension UIDevice {
    var is_iPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}

extension UIWindow {
    static var keyWindow: UIWindow? {
        // iOS13 or later
        if #available(iOS 13.0, *) {
            guard let scene = UIApplication.shared.connectedScenes.first,
                  let sceneDelegate = scene.delegate as? SceneDelegate else { return nil }
            return sceneDelegate.window
        } else {
            // iOS12 or earlier
            guard let appDelegate = UIApplication.shared.delegate else { return nil }
            return appDelegate.window ?? nil
        }
    }
}

public extension Array where Element: Equatable {
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
    // Append a element that is not in array:
    mutating func appendUnduplicate(object: Element) {
        if !contains(object) {
            append(object)
        }
    }
    
    func indexOf(object: Element) -> Int? {
        return (self as NSArray).contains(object) ? (self as NSArray).index(of: object) : nil
    }
    
    subscript(index index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        
        return self[index]
    }
}

public extension Array where Element: Comparable {
    func containsElements(as other: [Element]) -> Bool {
        for element in other {
            if !self.contains(element) { return false }
        }
        return true
    }
}

extension Int {
//    var convertToDuration: String {
//        let hour = Int(self / 3600)
//        let minutes = Int(self / 60)
//        let seconds = Int(self % 60)
//        return hour > 0 ? String(format:"%02d:%02d:%02d", hour, minutes, seconds) : String(format:"%02d:%02d", minutes, seconds)
//    }
    
    func secondsToHoursMinutesSeconds(_ forceWithHour: Bool = false) -> String {
        if forceWithHour {
            return String(format: "%02d:%02d:%02d", self / 3600, (self % 3600) / 60, (self % 3600) % 60)
        } else {
            return self > 3600
            ? String(format: "%02d:%02d:%02d", self / 3600, (self % 3600) / 60, (self % 3600) % 60)
            : String(format: "%02d:%02d", (self % 3600) / 60, (self % 3600) % 60)
        }
    }
}
extension CGFloat {
    var secondsToTimeString: String {
        let hours = Int(self / 3600)
        let minutes = Int((self.truncatingRemainder(dividingBy: 3600)) / 60)
        let remainingSeconds = Int(self.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d:%02d", hours, minutes, remainingSeconds)
    }
}
