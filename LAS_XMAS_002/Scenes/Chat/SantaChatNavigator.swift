//
//  VideoNoteNavigator.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 12/10/2023.
//

import Foundation
import UIKit

protocol SantaChatNavigatorType {
    func back()
}

struct SantaChatNavigator: SantaChatNavigatorType {
    
    let navigationController : UINavigationController
    
    func back() {
        navigationController.popViewController(animated: true)
    }
}
