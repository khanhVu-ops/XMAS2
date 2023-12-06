//
//  CallService.swift
//  LAS_XMAS_002
//
//  Created by Khanh Vu on 13/11/2023.
//

import Foundation
import UIKit

class CallService {
    
    static let shared = CallService()
    
    func openVideoCall() {
        Toast.show("The call will start after \(UserDefaults.schedule) seconds, please do not close the application")
        asynAfter(Double(UserDefaults.schedule)) {
            self.goToVideoCall()
        }
    }
    
    func openAudioCall() {
        Toast.show("The call will start after \(UserDefaults.schedule) seconds, please do not close the application")
        asynAfter(Double(UserDefaults.schedule)) {
            self.goToAudioCall()
        }
    }
    
    func goToVideoCall() {
        guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
            return
        }
        guard let url = URL(string: UserDefaults.videoCallURL ?? "") else {
            return
        }
        let santaCallNavigator = SantaCallNavigator(navigationController: navigationController)
        let santaCallUsecase = SantaCallUseCase(santaCallType: .incomingVideo, santaCallURL: url)
        let santaCallVM = SantaCallViewModel(navigator: santaCallNavigator, service: santaCallUsecase)
        let santaCallVC = SantaCallViewController(viewModel: santaCallVM)
        

        navigationController.pushViewController(santaCallVC, animated: true)
    }
    
    func goToAudioCall() {
        guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
            return
        }
        guard let url = URL(string: UserDefaults.videoCallURL ?? "") else {
            return
        }

        let santaCallNavigator = SantaCallNavigator(navigationController: navigationController)
        let santaCallUsecase = SantaCallUseCase(santaCallType: .incomingAudio, santaCallURL: url)
        let santaCallVM = SantaCallViewModel(navigator: santaCallNavigator, service: santaCallUsecase)
        let santaCallVC = SantaCallViewController(viewModel: santaCallVM)
        navigationController.pushViewController(santaCallVC, animated: true)
    }
}
