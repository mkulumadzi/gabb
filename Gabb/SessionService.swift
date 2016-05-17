//
//  SessionService.swift
//  Gabb
//
//  Created by Evan Waters on 4/22/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import Foundation
import SwiftyJSON

class SessionService : RestService {

    class func startSession(gabbPlayer: GabbPlayer) {
        let url = "https://gabb.herokuapp.com/session/start"
        let headers = RestService.headersForJsonRequestWithLoggedInUser()
        let parameters = SessionService.parametersForSession(gabbPlayer)
        
        RestService.postRequest(url, parameters: parameters, headers: headers, completion: { (error, result) -> Void in
            if let error = error {
                print (error)
            } else if let result = result {
                print(result)
            }
        })
    }
    
    class func stopSession(gabbPlayer: GabbPlayer) {
        let url = "https://gabb.herokuapp.com/session/stop"
        let headers = RestService.headersForJsonRequestWithLoggedInUser()
        let parameters = SessionService.parametersForSession(gabbPlayer)
        RestService.postRequest(url, parameters: parameters, headers: headers, completion: { (error, result) -> Void in
            if let error = error {
                print (error)
            } else if let result = result {
                print(result)
            }
        })
    }
    
    class func finishSession(gabbPlayer: GabbPlayer) {
        let url = "https://gabb.herokuapp.com/session/finish"
        let headers = RestService.headersForJsonRequestWithLoggedInUser()
        let parameters = SessionService.parametersForSession(gabbPlayer)
        RestService.postRequest(url, parameters: parameters, headers: headers, completion: { (error, result) -> Void in
            if let error = error {
                print (error)
            } else if let result = result {
                print(result)
            }
        })
    }
    
    class func getLastSessionForEpisode(episodeURL: String, completion: (result: NSDictionary?) -> Void) {
        let episodeHash = episodeURL.toHash()
        let url = "https://gabb.herokuapp.com/session/last?episode_hash=\(episodeHash)"
        let headers = RestService.headersForJsonRequestWithLoggedInUser()
        self.getRequest(url, headers: headers, completion: { (error, result) -> Void in
            if let lastSession = result as? NSDictionary {
                completion(result: lastSession)
            } else {
                completion(result: nil)
            }
        })
    }
    
    class func getRecentSessions(completion: (result: [NSDictionary]?) -> Void) {
        let url = "https://gabb.herokuapp.com/sessions?limit=3"
        let headers = RestService.headersForJsonRequestWithLoggedInUser()
        self.getRequest(url, headers: headers, completion: {(error, result) -> Void in
            if let sessions = result as? [NSDictionary] {
                completion(result: sessions)
            } else {
                completion(result: nil)
            }
        })
    }
    
    // MARK: Private
    
    private class func parametersForSession(gabbPlayer: GabbPlayer) -> [String: AnyObject] {
        let episodeJSON = JSON(gabbPlayer.episode)
        let episodeURL = episodeJSON["audio_url"].stringValue
        let episodeHash = episodeURL.toHash()
        let episodeTitle = episodeJSON["title"].stringValue
        
        let podcastJSON = JSON(gabbPlayer.podcast)
        let podcastDictionary:[String: AnyObject] = ["title": podcastJSON["title"].stringValue, "image_url": podcastJSON["image_url"].stringValue, "feed_url": podcastJSON["feed_url"].stringValue, "podcast_id": podcastJSON["podcast_id"].intValue]
        
        let parameters:[String: AnyObject] = ["podcast": podcastDictionary, "title": episodeTitle, "episode_url": episodeURL, "episode_hash": episodeHash, "time_value": NSInteger(gabbPlayer.player.currentTime().value), "time_scale": NSInteger(gabbPlayer.player.currentTime().timescale)]
        
        print(parameters)
        
        return parameters
    }
    
}