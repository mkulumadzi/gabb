//
//  GabbChatSender.swift
//  Gabb
//
//  Created by Evan Waters on 4/29/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

public class GabbChatSender {
    
    public var onMessageChanged: ((message: MessageModelProtocol) -> Void)?
    
    public func sendTextMessage(message: TextMessageModel) {
        ChatService.sendTextMessage(message, completion: {(error, result) -> Void in
            if let error = error {
                print(error)
                self.updateMessage(message, status: .Failed)
            } else {
                if let array = result as? NSArray {
                    print(array) // Successful post will return an array with a status and a header
                    self.updateMessage(message, status: .Success)
                } else {
                    self.updateMessage(message, status: .Failed)
                }
            }
        })
    }
    
    private func updateMessage(message: MessageModelProtocol, status: MessageStatus) {
        if message.status != status {
            message.status = status
            self.notifyMessageChanged(message)
        }
    }
    
    private func notifyMessageChanged(message: MessageModelProtocol) {
        self.onMessageChanged?(message: message)
    }
}
