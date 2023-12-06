//
//  MediaModel.swift
//  LAS_XMAS_002
//
//  Created by Khanh Vu on 12/11/2023.
//

import Foundation

struct MediaDataModel: Codable {
    let data: [MediaModel]
}

struct MediaModel: Codable {
    let id: Int
    let url: String
    let thumbnail: String?
    let name: String?
    var isPlay: Bool? = false
}
