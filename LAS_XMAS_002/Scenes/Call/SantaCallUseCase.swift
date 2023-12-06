//
//  VideoNoteUseCase.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 12/10/2023.
//

import Foundation
import RxSwift
import RxCocoa

enum SantaCallType {
    case incomingAudio
    case incomingVideo
    case audioCall
    case videoCall
    
    
    var image: UIImage? {
        switch self {
        case .incomingAudio:
            return .img_audio_calling
        case .incomingVideo:
            return .img_video_calling
        case .audioCall:
            return .img_audio_calling
        case .videoCall:
            return nil
        }
    }
    
    var statusLabelIncoming: String {
        switch self {
        case .incomingAudio:
            return "Audio Calling..."
        case .incomingVideo:
            return "Video Calling..."
        default:
            return "00:00"
        }
    }
}

protocol SantaCallUseCaseType {
    
}

struct SantaCallUseCase: SantaCallUseCaseType {
    var santaCallType: SantaCallType
    var santaCallURL: URL
    
}
