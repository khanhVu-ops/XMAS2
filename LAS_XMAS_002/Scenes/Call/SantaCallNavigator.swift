//
//  VideoNoteNavigator.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 12/10/2023.
//

import Foundation
import UIKit

protocol SantaCallNavigatorType {
    func refuseIncomingCall()
    func showSettingCamera()
}

struct SantaCallNavigator: SantaCallNavigatorType {
    
    let navigationController : UINavigationController
    
    func refuseIncomingCall() {
        navigationController.popViewController(animated: true)
    }
    
    func showSettingCamera() {
        navigationController.showAlertSetting(title: "App", message: "Allow camera access for video calls")
    }
}
