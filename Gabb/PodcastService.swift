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
    
    class func getPodcastsForEndpoint(endpoint: String, completion: (result: [NSDictionary]?) -> Void) {
        let url = "https://gabb.herokuapp.com/podcasts\(endpoint)"
        let headers = RestService.headersForJsonRequestWithLoggedInUser()
        self.getRequest(url, headers: headers, completion: { (error, result) -> Void in
            if let podcastArray = self.getPodcastArrayFromResult(result) {
                completion(result: podcastArray)
            }
            else {
                completion(result: nil)
            }
        })
    }
    
    class func getPodcastCategories(completion: (result: [NSDictionary]?) -> Void) {
        let url = "https://gabb.herokuapp.com/podcasts/categories"
        self.getRequest(url, headers: nil, completion: { (error, result) -> Void in
            
            // For some reason Feedwrangler returns a key of "podcasts" that has an array of categories on this endpoint
            if let podcastArray = self.getPodcastArrayFromResult(result) {
                completion(result: podcastArray)
            }
            else {
                completion(result: nil)
            }
        })
    }
    
    class func getPodcast(podcast_id: NSInteger, completion: (result: NSDictionary?) -> Void) {
        let url = "https://gabb.herokuapp.com/podcasts/show?podcast_id=\(podcast_id)"
        self.getRequest(url, headers: nil, completion: { (error, result) -> Void in
            if let podcast = result as? NSDictionary {
                completion(result: podcast)
            }
            else {
                completion(result: nil)
            }
        })
    }
    
    class func getPodcastDetails(podcast_id: NSInteger, completion: (result: NSMutableDictionary?) -> Void) {
        let url = "https://gabb.herokuapp.com/podcast/id/\(podcast_id)"
        let headers = RestService.headersForJsonRequestWithLoggedInUser()
        self.getRequest(url, headers: headers, completion: { (error, result) -> Void in
            if let podcast = result as? NSMutableDictionary {
                completion(result: podcast)
            } else {
                completion(result: nil)
            }
//            if let episodeArray = self.getEpisodeArrayFromResult(result) {
//                completion(result: episodeArray)
//            }
//            else {
//                completion(result: nil)
//            }
        })
    }
    
    class func searchPodcasts(searchTerm: String, completion: (result: [NSDictionary]?) -> Void) {
        let url = "https://gabb.herokuapp.com/podcasts/search?search_term=\(searchTerm)"
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
            if let result = dictionary.valueForKey("podcasts") as? [NSDictionary] {
                var podcastArray = [NSDictionary]()
                
                // Hacky solution of filtering out the podcasts that come back with names like '404 Not Found'
                for podcast in result {
                    let json = JSON(podcast)
                    let title = json["title"].stringValue
                    if title.rangeOfString("400") == nil && title.rangeOfString("401") == nil && title.rangeOfString("403") == nil && title.rangeOfString("404") == nil {
                        podcastArray.append(podcast)
                    }
                }
                
                return podcastArray
            }
        }
        return nil
    }
    
//    private class func getEpisodeArrayFromResult(result: AnyObject?) -> [NSDictionary]? {
//        if let podcast = result as? NSDictionary {
//            if let episodeArray = podcast.valueForKey("recent_episodes") as? [NSDictionary] {
//                return episodeArray
//            }
//        }
//        return nil
//    }
    
}