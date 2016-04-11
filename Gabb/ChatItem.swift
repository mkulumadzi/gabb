//
//  ChatItem.swift
//  Gabb
//
//  Created by Evan Waters on 4/10/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class ChatItem:NSObject, ChatItemProtocol {
    
    private var _type:ChatItemType!
    private var _uid:String!
    
    init(type:ChatItemType, uid: String) {
        _uid = uid
        _type = type
    }
    
    var uid:String {
        if _uid != nil {
            return _uid
        }
        else { // Not sure why I have to do this, but I seem to have to make this value always available
            return ""
        }
    }
    
    var type:ChatItemType {
        if _type != nil {
            return _type
        }
        else {
            return ""
        }
    }
    
}