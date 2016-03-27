//
//  PodcastService.swift
//  Gabb
//
//  Created by Evan Waters on 3/26/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import Foundation
import SwiftyJSON

class PodcastService : RestService {
    
    class func getPopularPodcasts(completion: (result: [NSDictionary]?) -> Void) {
        let url = "https://gabb.herokuapp.com/podcasts/popular"
        self.getRequest(url, headers: nil, completion: { (error, result) -> Void in
            if let podcastArray = self.getPodcastArrayFromResult(result) {
                completion(result: podcastArray)
            }
            else {
                completion(result: nil)
            }
        })
    }
    
    private class func getPodcastArrayFromResult(result: AnyObject?) -> [NSDictionary]? {
        if let dictionary = result as? NSDictionary {
            if let podcastArray = dictionary.valueForKey("podcasts") as? [NSDictionary] {
                return podcastArray
            }
        }
        return nil
    }
    
}