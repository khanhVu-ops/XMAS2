//
//  AppError.swift
//  BaseRxswift_MVVM
//
//  Created by Khanh Vu on 27/09/2023.
//

import Foundation

enum ErrorType: Int {
    case app = 0
    case network = 1
    case firebase = 2
    case UNAUTHORIZED = 401
    case INVALID_TOKEN = 403
}

struct AppError: Error {
    let code: Int
    let message: String
}
