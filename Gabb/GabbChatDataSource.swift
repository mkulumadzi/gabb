//
//  ChatDataSource.swift
//  Gabb
//
//  Created by Evan Waters on 4/15/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions
import SwiftyJSON

class GabbChatDataSource: ChatDataSourceProtocol {
    
    var nextMessageId: Int = 0
    let preferredMaxWindowSize = 500
    
    var podcast:NSDictionary!
    
    var chats:[NSMutableDictionary]!
    
    var slidingWindow: SlidingDataSource<ChatItemProtocol>!
    
    init(podcast: NSDictionary!, chats: [NSMutableDictionary]!) {
        
        self.podcast = podcast
        self.chats = chats
        let count = self.chats.count
        
        self.slidingWindow = SlidingDataSource(count: count, pageSize: 10) { () -> ChatItemProtocol in
            defer { self.nextMessageId += 1 }
            return self.createTextMessageModel(self.chats[self.nextMessageId])
        }
    }
    
    func createTextMessageModel(chat: NSMutableDictionary) -> TextMessageModel {
        let json = JSON(chat)
        let uid = json["_id"]["$oid"].stringValue
        let text = json["text"].stringValue
        let date = NSDate(dateString: json["created_at"].stringValue)
        let senderId = json["person_id"]["$oid"].stringValue
        let isIncoming = (senderId == currentUser.id ? false : true)
        let messageModel = createMessageModel(uid, senderId: senderId, isIncoming: isIncoming, date: date, type: TextMessageModel.chatItemType)
        let textMessageModel = TextMessageModel(messageModel: messageModel, text: text)
        return textMessageModel
    }
    
    func createOutgoingTextMessage(text: String) -> TextMessageModel {
        let senderId = currentUser.id
        let tempUid = "\(nextMessageId)"
        let date = NSDate()
        let isIncoming = false
        let messageModel = createMessageModel(tempUid, senderId: senderId, isIncoming: isIncoming, date: date, type: TextMessageModel.chatItemType)
        let textMessageModel = TextMessageModel(messageModel: messageModel, text: text)
        return textMessageModel
    }
    
    func createMessageModel(uid: String, senderId: String, isIncoming: Bool, date: NSDate, type: String) -> GabbMessageModel {
        let senderId = senderId
        let messageStatus = MessageStatus.Success
        let messageModel = GabbMessageModel(uid: uid, senderId: senderId, type: type, isIncoming: isIncoming, date: date, status: messageStatus)
        messageModel.podcastId = JSON(self.podcast)["podcast_id"].intValue
        return messageModel
    }
    
    init(messages: [ChatItemProtocol], pageSize: Int) {
        self.slidingWindow = SlidingDataSource(items: messages, pageSize: pageSize)
    }
    
    // Create a real message sender
    lazy var messageSender: GabbChatSender = {
        let sender = GabbChatSender()
        sender.onMessageChanged = { [weak self] (message) in
            guard let sSelf = self else { return }
            sSelf.delegate?.chatDataSourceDidUpdate(sSelf)
        }
        return sender
    }()
    
    var hasMoreNext: Bool {
        return self.slidingWindow.hasMore()
    }
    
    var hasMorePrevious: Bool {
        return self.slidingWindow.hasPrevious()
    }
    
    var chatItems: [ChatItemProtocol] {
        return self.slidingWindow.itemsInWindow
    }
    
    weak var delegate: ChatDataSourceDelegateProtocol?
    
    func loadNext(completion: () -> Void) {
        self.slidingWindow.loadNext()
        self.slidingWindow.adjustWindow(focusPosition: 1, maxWindowSize: self.preferredMaxWindowSize)
        completion()
    }
    
    func loadPrevious(completion: () -> Void) {
        self.slidingWindow.loadPrevious()
        self.slidingWindow.adjustWindow(focusPosition: 0, maxWindowSize: self.preferredMaxWindowSize)
        completion()
    }
    
    func addTextMessage(text: String) {
        let message = createOutgoingTextMessage(text)
        self.nextMessageId += 1
        self.messageSender.sendTextMessage(message)
        self.slidingWindow.insertItem(message, position: .Bottom)
        self.delegate?.chatDataSourceDidUpdate(self)
    }
    
    func adjustNumberOfMessages(preferredMaxCount preferredMaxCount: Int?, focusPosition: Double, completion:(didAdjust: Bool) -> Void) {
        let didAdjust = self.slidingWindow.adjustWindow(focusPosition: focusPosition, maxWindowSize: preferredMaxCount ?? self.preferredMaxWindowSize)
        completion(didAdjust: didAdjust)
    }
    
}

extension TextMessageModel {
    static var chatItemType: ChatItemType {
        return "text"
    }
}

extension PhotoMessageModel {
    static var chatItemType: ChatItemType {
        return "photo"
    }
}