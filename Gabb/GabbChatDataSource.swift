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

class GabbChatDataSource:NSObject, ChatDataSourceProtocol {
    
    private var _hasMoreNext: Bool!
    private var _hasMorePrevious: Bool!
    private var _chatItems:[GabbChatItem]!
    
    weak var delegate: ChatDataSourceDelegateProtocol?
    
    func loadNext(completion: () -> Void) {
        
    }
    
    func loadPrevious(completion: () -> Void) {
        
    }
    
    func adjustNumberOfMessages(preferredMaxCount preferredMaxCount: Int?, focusPosition: Double, completion: (didAdjust: Bool) -> Void) {
        // If you want, implement message count contention for performance, otherwise just call completion(false)
    }
    
    var hasMoreNext: Bool {
        return _hasMoreNext
    }
    
    var hasMorePrevious: Bool {
        return _hasMorePrevious
    }
    
    var chatItems: [ChatItemProtocol] {
        return _chatItems
    }
    
//    var hasMoreNext: Bool { get }
//    var hasMorePrevious: Bool { get }
//    var chatItems: [ChatItemProtocol] { get }
//    weak var delegate: ChatDataSourceDelegateProtocol? { get set }
//    
//    func loadNext(completion: () -> Void)
//    func loadPrevious(completion: () -> Void)
//    func adjustNumberOfMessages(preferredMaxCount preferredMaxCount: Int?, focusPosition: Double, completion:(didAdjust: Bool) -> Void) // If you want, implement message count contention for performance, otherwise just call completion(false)
    
}