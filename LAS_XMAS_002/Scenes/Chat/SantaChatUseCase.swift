//
//  VideoNoteUseCase.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 12/10/2023.
//

import Foundation
import RxSwift
import RxCocoa


protocol SantaChatUseCaseType {
    func sendMessage(_ message: String) -> Single<MessageModel>
}

struct SantaChatUseCase: SantaChatUseCaseType {
    func sendMessage(_ message: String) -> Single<MessageModel> {
        return ChatService.shared.sendMessage(message)
    }
}
