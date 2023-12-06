//
//  FrameModel.swift
//  LAS_XMAS_002
//
//  Created by Khanh Vu on 13/11/2023.
//

import Foundation

struct FrameDataModel: Codable {
    let data: [FrameModel]
}

struct FrameModel: Codable {
    let id: Int
    let url: String
    let name: String
}
