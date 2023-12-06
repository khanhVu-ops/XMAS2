//
//  VideoNoteNavigator.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 12/10/2023.
//

import Foundation
import UIKit

protocol XmasFrameNavigatorType {
    func back()
    func goToFrameImage(url: String)
}

struct XmasFrameNavigator: XmasFrameNavigatorType {
    
    let navigationController : UINavigationController
    
    func back() {
        navigationController.popViewController(animated: true)
    }
    
    func goToFrameImage(url: String) {
        let fmNavigator = FrameMergeNavigator(navigationController: navigationController)
        let fmUC = FrameMergeUseCase(frameURL: url)
        let fmVM = FrameMergeViewModel(navigator: fmNavigator, service: fmUC)
        let fmVC = FrameMergeViewController(viewModel: fmVM)
        navigationController.pushViewController(fmVC, animated: true)
    }
}
