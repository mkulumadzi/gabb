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

    class func startSession(episodeURL: String, timeValue: Int64, timeScale: Int32) {
        let episodeHash = episodeURL.toHash()
        let url = "https://gabb.herokuapp.com/session/start"
        let headers = RestService.headersForJsonRequeestWithLoggedInUser()
        let parameters:[String: AnyObject] = ["episode_url": episodeURL, "episode_hash": episodeHash, "time_value": NSInteger(timeValue), "time_scale": NSInteger(timeScale)]
        RestService.postRequest(url, parameters: parameters, headers: headers, completion: { (error, result) -> Void in
            if let error = error {
                print (error)
            } else if let result = result {
                print(result)
            }
        })
    }
    
    class func stopSession(episodeURL: String, timeValue: Int64, timeScale: Int32) {
        let episodeHash = episodeURL.toHash()
        let url = "https://gabb.herokuapp.com/session/stop"
        let headers = RestService.headersForJsonRequeestWithLoggedInUser()
        let parameters:[String: AnyObject] = ["episode_url": episodeURL, "episode_hash": episodeHash, "time_value": NSInteger(timeValue), "time_scale": NSInteger(timeScale)]
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
        let headers = RestService.headersForJsonRequeestWithLoggedInUser()
        self.getRequest(url, headers: headers, completion: { (error, result) -> Void in
            if let lastSession = result as? NSDictionary {
                completion(result: lastSession)
            } else {
                completion(result: nil)
            }
        })
    }
    
}