//
//  VideoNoteNavigator.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 12/10/2023.
//

import Foundation
import UIKit

protocol HomeNavigatorType {
    func goToSantaVideoCall()
    func goToSantaAudioCall()
    func goToSantaChat()
    func goToXmasFrame()
    func goToChooseVideos()
    func goToChooseAudio()
}

struct HomeNavigator: HomeNavigatorType {
    
    let navigationController : UINavigationController
    
    func goToSantaVideoCall() {
        guard let url = Bundle.main.url(forResource: "call", withExtension: "mp4") else { return }

        let santaCallNavigator = SantaCallNavigator(navigationController: navigationController)
        let santaCallUsecase = SantaCallUseCase(santaCallType: .incomingVideo, santaCallURL: url)
        let santaCallVM = SantaCallViewModel(navigator: santaCallNavigator, service: santaCallUsecase)
        let santaCallVC = SantaCallViewController(viewModel: santaCallVM)
        navigationController.pushViewController(santaCallVC, animated: true)
    }
    
    func goToSantaAudioCall() {
        guard let url = Bundle.main.url(forResource: "call", withExtension: "mp4") else { return }

        let santaCallNavigator = SantaCallNavigator(navigationController: navigationController)
        let santaCallUsecase = SantaCallUseCase(santaCallType: .incomingAudio, santaCallURL: url)
        let santaCallVM = SantaCallViewModel(navigator: santaCallNavigator, service: santaCallUsecase)
        let santaCallVC = SantaCallViewController(viewModel: santaCallVM)
        navigationController.pushViewController(santaCallVC, animated: true)
    }
    
    func goToSantaChat() {
        let santaChatNavigator = SantaChatNavigator(navigationController: navigationController)
        let santaChatVM = SantaChatViewModel(navigator: santaChatNavigator, service: SantaChatUseCase())
        let santaChatVC = SantaChatViewController(viewModel: santaChatVM)
        navigationController.pushViewController(santaChatVC, animated: true)
    }
    
    func goToXmasFrame() {
        let xmasNavigator = XmasFrameNavigator(navigationController: navigationController)
        let xmasVM = XmasFrameViewModel(navigator: xmasNavigator, service: XmasFrameUseCase())
        let xmasVC = XmasFrameViewController(viewModel: xmasVM)
        navigationController.pushViewController(xmasVC, animated: true)
    }
    
    func goToChooseVideos() {
        let chooseNavigator = ChooseVideoCallNavigator(navigationController: navigationController)
        let chooseUC = ChooseVideoCallUseCase(callType: .video)
        let chooseVM = ChooseVideoCallViewModel(navigator: chooseNavigator, service: chooseUC)
        let chooseVC = ChooseVideoCallViewController(viewModel: chooseVM)
        navigationController.pushViewController(chooseVC, animated: true)
    }
    
    func goToChooseAudio() {
        let chooseNavigator = ChooseVideoCallNavigator(navigationController: navigationController)
        let chooseUC = ChooseVideoCallUseCase(callType: .audio)
        let chooseVM = ChooseVideoCallViewModel(navigator: chooseNavigator, service: chooseUC)
        let chooseVC = ChooseVideoCallViewController(viewModel: chooseVM)
        navigationController.pushViewController(chooseVC, animated: true)
    }
}
