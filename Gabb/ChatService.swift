//
//  ChatService.swift
//  Gabb
//
//  Created by Evan Waters on 4/29/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import Foundation
import SwiftyJSON

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

}