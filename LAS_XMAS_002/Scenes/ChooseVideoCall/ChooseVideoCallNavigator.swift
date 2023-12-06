//
//  VideoNoteNavigator.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 12/10/2023.
//

import Foundation
import UIKit
import AVKit

protocol ChooseVideoCallNavigatorType {
    func back()
    func previewVideo(asset: AVAsset)
}

struct ChooseVideoCallNavigator: ChooseVideoCallNavigatorType {
    
    let navigationController : UINavigationController
    
    func back() {
        navigationController.popViewController(animated: true)
    }
    
    func previewVideo(asset: AVAsset) {
      
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        navigationController.present(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
    }
    
}
