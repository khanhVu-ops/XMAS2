//
//  VideoNoteUseCase.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 12/10/2023.
//

import Foundation
import RxSwift
import RxCocoa


protocol XmasFrameUseCaseType {
    func getFrames() -> Single<FrameDataModel>
}

struct XmasFrameUseCase: XmasFrameUseCaseType {
    
    func getFrames() -> Single<FrameDataModel> {
        return GithubService.shared.getFrame()
    }
}
