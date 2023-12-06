//
//  UIButton+Rx+Extensions.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 23/10/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIButton {
    var impactTap: ControlEvent<Void> {
        let source = controlEvent(.touchUpInside)
        return ControlEvent(events: source.map { _ in
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        })
    }
}
