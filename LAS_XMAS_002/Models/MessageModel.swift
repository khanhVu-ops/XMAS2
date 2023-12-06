//
//  MessageModel.swift
//  LAS_XMAS_002
//
//  Created by Khanh Vu on 15/11/2023.
//

import Foundation

struct MessageModel {
    let message: String
    let isSender: Bool
}

struct SantaResponse: Decodable {
    let message: String
    let response: String
    let code: String
}
