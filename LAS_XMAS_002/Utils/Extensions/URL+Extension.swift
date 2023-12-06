//
//  URL+Extension.swift
//  BaseRxswift_MVVM
//
//  Created by Khanh Vu on 27/09/2023.
//

import Foundation

extension URL {
    func fileSize() -> Double {
        var fileSize: Double = 0.0
        var fileSizeValue = 0.0
        try? fileSizeValue = ((self.resourceValues(forKeys: [URLResourceKey.fileSizeKey]).allValues.first?.value as? Double) ?? 0.0)
        if fileSizeValue > 0.0 {
            fileSize = (Double(fileSizeValue) / (1024 * 1024))
        }
        return fileSize
    }
}
