//
//  ChatService.swift
//  Gabb
//
//  Created by Evan Waters on 4/29/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import Foundation
import SwiftyJSON
import Chatto
import ChattoAdditions

class ChatService : RestService {
    
    class func getChatsForPodcast(podcast: NSDictionary, completion: (result: [NSMutableDictionary]?) -> Void) {
        let podcast_id = JSON(podcast)["podcast_id"].intValue
        let url = "https://gabb.herokuapp.com/chats?podcast_id=\(podcast_id)"
        let headers = RestService.headersForJsonRequeestWithLoggedInUser()
        self.getRequest(url, headers: headers, completion: { (error, result) -> Void in
            if let chats = result as? [NSMutableDictionary] {
                completion(result: chats)
            } else {
                completion(result: nil)
            }
        })
    }
    
    class func sendTextMessage(podcastId: NSInteger, textMessage:TextMessageModel, completion: (error: ErrorType?, result: AnyObject?) -> Void) {
        let url = "https://gabb.herokuapp.com/chat"
        let headers = RestService.headersForJsonRequeestWithLoggedInUser()
        let parameters:[String: AnyObject] = ["podcast_id": podcastId, "text": textMessage.text]
        RestService.postRequest(url, parameters: parameters, headers: headers, completion: { (error, result) -> Void in
            completion(error: error, result: result)
        })
    }

}