//
//  ChatService.swift
//  LAS_XMAS_002
//
//  Created by Khanh Vu on 15/11/2023.
//

import Foundation
import RxSwift
import RxCocoa

class ChatService: BaseService {
    static let shared = ChatService()
    
    private override init() {
        
    }
    
    let baseURL = "https://funxmas.top/api/Asksanta"
    let uuid = getDeviceUUID()
    
    func sendMessage(_ message: String) -> Single<MessageModel> {
        let body: [String : Any] = ["message" : message,
                                    "guidId" : uuid ?? ""]
        print("uuid: ", uuid)
        return rxRequest(baseURL, .post, parameters: body, of: SantaResponse.self)
            .map { MessageModel(message: $0.response, isSender: false)}
    }
}
