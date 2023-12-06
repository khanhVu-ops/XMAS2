//
//  Constants.swift
//  LAS_ANIME_004
//
//  Created by Khanh Vu on 05/10/2023.
//

import Foundation
import UIKit

//MARK:  UIImage
extension UIImage {
    
    // Home
    static var img_audio_call: UIImage? {
        return UIImage(named: "img_audio_call")
    }
    
    static var img_chat_with_santa: UIImage? {
        return UIImage(named: "img_chat_with_santa")
    }
    
    static var img_xmas_frame: UIImage? {
        return UIImage(named: "img_xmas_frame")
    }
    
    static var img_video_call: UIImage? {
        return UIImage(named: "img_video_call")
    }
    
    // Calling
    static var ic_accept_calling: UIImage? {
        return UIImage(named: "ic_accept_calling")
    }
    
    //
    static var ic_cancel_calling_video: UIImage? {
        return UIImage(named: "ic_cancel_calling_video")
    }
    
    static var ic_cancel_calling: UIImage? {
        return UIImage(named: "ic_cancel_calling")
    }
    
    static var ic_back: UIImage? {
        return UIImage(named: "ic_back")
    }
    
    static var ic_mark: UIImage? {
        return UIImage(named: "ic_mark")
    }
    
    static var ic_mark_enable: UIImage? {
        return UIImage(named: "ic_mark_enable")
    }
    
    static var ic_pause: UIImage? {
        return UIImage(named: "ic_pause")
    }
    
    static var ic_play: UIImage? {
        return UIImage(named: "ic_play")
    }
    
    static var ic_micro: UIImage? {
        return UIImage(named: "ic_micro")
    }
    
    static var ic_mute: UIImage? {
        return UIImage(named: "ic_mute")
    }
    
    static var ic_rotate_camera: UIImage? {
        return UIImage(named: "ic_rotate_camera")
    }
    
    static var ic_sent: UIImage? {
        return UIImage(named: "ic_sent")
    }
    
    static var ic_speaker: UIImage? {
        return UIImage(named: "ic_speaker")
    }
    
    static var ic_micro_enable: UIImage? {
        return UIImage(named: "ic_micro_enable")
    }
    
    static var ic_speaker_enable: UIImage? {
        return UIImage(named: "ic_speaker_enable")
    }
    
    static var ic_mute_enable: UIImage? {
        return UIImage(named: "ic_mute_enable")
    }
    
    static var img_video_calling: UIImage? {
        return UIImage(named: "img_video_calling")
    }
    
    static var img_audio_calling: UIImage? {
        return UIImage(named: "img_audio_calling")
    }
    
    static var img_xmas_frame1: UIImage? {
        return UIImage(named: "img_xmas_frame1")
    }
    
    static var img_xmas_frame2: UIImage? {
        return UIImage(named: "img_xmas_frame2")
    }
}

//MARK: UIColor
extension UIColor {
    static var colorRed: UIColor? {
        return UIColor(hex: "#D83D3D")
    }
    
    static var backgroundColor: UIColor? {
        return UIColor(hex: "#121212")
    }
    
//    static var colorYelow: UIColor? {
//        return UIColor(hex: "#F4FF4A")
//    }
//
//    static var colorGreen: UIColor? {
//        return UIColor(hex: "#55FF3E", alpha: 0.9)
//    }
//
//    static var colorTextGray: UIColor? {
//        return UIColor(hex: "#727272")
//    }
//
//    static var tabbarTextDeseletect: UIColor? {
//        return UIColor(hex: "#44506D")
//    }
//
//    static var colorBorder: UIColor? {
//        return UIColor(hex: "#979797")
//    }
//
//    static var colorBgr: UIColor? {
//        return UIColor(hex: "#D8D8D8")
//    }
}

//MARK: UIFont
extension UIFont {
    static func helveticaNeue_regular(ofSize: CGFloat) -> UIFont? {
        return UIFont(name: "HelveticaNeue-Regular", size: ofSize)
    }
    
    static func helveticaNeue_medium(ofSize: CGFloat) -> UIFont? {
        return UIFont(name: "HelveticaNeue-Medium", size: ofSize)
    }
    
    static func helveticaNeue_bold(ofSize: CGFloat) -> UIFont? {
        return UIFont(name: "HelveticaNeue-Bold", size: ofSize)

    }
    
    static func pilgi_regular(ofSize: CGFloat) -> UIFont? {
        return UIFont(name: "pilgi-regular.ttf", size: ofSize)

    }
    
    static func playball_Regular(ofSize: CGFloat) -> UIFont? {
        return UIFont(name: "Playball-Regular.ttf", size: ofSize)

    }
}
