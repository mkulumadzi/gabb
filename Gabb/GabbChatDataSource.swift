//
//  ChatDataSource.swift
//  Gabb
//
//  Created by Evan Waters on 4/15/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import Foundation
import Chatto

class GabbChatDataSource: ChatDataSourceProtocol {
    
    var nextMessageId: Int = 0
    let preferredMaxWindowSize = 500
    
    var fakeMessages:NSMutableDictionary!
    
    var slidingWindow: SlidingDataSource<ChatItemProtocol>!
    
    // Change this to not take a static count - just get the messages for this podcast (or maybe take the total count of the messages for this podcast?
    init(count: Int, pageSize: Int) {
        self.slidingWindow = SlidingDataSource(count: count, pageSize: pageSize) { () -> ChatItemProtocol in
            defer { self.nextMessageId += 1 }
            
            print(self.nextMessageId)
            
            // Change this to get a real message from a real data source
            return FakeMessageFactory.createChatItem("\(self.nextMessageId)")
        }
    }
    
    init(messages: [ChatItemProtocol], pageSize: Int) {
        self.slidingWindow = SlidingDataSource(items: messages, pageSize: pageSize)
    }
    
    // Create a real message sender
    lazy var messageSender: FakeMessageSender = {
        let sender = FakeMessageSender()
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
        let uid = "\(self.nextMessageId)"
        self.nextMessageId += 1
        let message = createTextMessageModel(uid, text: text, isIncoming: false)
        self.messageSender.sendMessage(message)
        self.slidingWindow.insertItem(message, position: .Bottom)
        self.delegate?.chatDataSourceDidUpdate(self)
    }
    
    func addPhotoMessage(image: UIImage) {
        let uid = "\(self.nextMessageId)"
        self.nextMessageId += 1
        let message = createPhotoMessageModel(uid, image: image, size: image.size, isIncoming: false)
        self.messageSender.sendMessage(message)
        self.slidingWindow.insertItem(message, position: .Bottom)
        self.delegate?.chatDataSourceDidUpdate(self)
    }
    
    func adjustNumberOfMessages(preferredMaxCount preferredMaxCount: Int?, focusPosition: Double, completion:(didAdjust: Bool) -> Void) {
        let didAdjust = self.slidingWindow.adjustWindow(focusPosition: focusPosition, maxWindowSize: preferredMaxCount ?? self.preferredMaxWindowSize)
        completion(didAdjust: didAdjust)
    }
    
}