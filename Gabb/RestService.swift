//
//  RestService.swift
//  Gabb
//
//  Created by Evan Waters on 3/26/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class RestService {
    
    class func getRequest(requestURL:String, headers: [String: String]?, completion: (error: ErrorType?, result: AnyObject?) -> Void) {
        
        Alamofire.request(.GET, requestURL, headers: headers)
            .responseJSON { (response) in
                switch response.result {
                case .Success (let result):
                    if let dataArray = result as? [AnyObject] {
                        completion(error: nil, result: dataArray)
                    }
                    else {
                        completion(error: nil, result: result)
                    }
                case .Failure(let error):
                    var statusCode:Int!
                    if let response = response.response {
                        statusCode = response.statusCode
                    }
                    completion(error: error, result: statusCode)
                }
        }
    }
    
    class func postRequest(requestURL:String, parameters: [String: AnyObject]?, headers: [String: String]?, completion: (error: ErrorType?, result: AnyObject?) -> Void) {
        Alamofire.request(.POST, requestURL, parameters: parameters, headers: headers, encoding: .JSON)
            .responseJSON { (response) in
                if let statusCode = response.response?.statusCode {
                    if statusCode == 201 {
                        completion(error: nil, result: [201, response.response?.allHeaderFields["Location"] as! String])
                    }
                    else if statusCode == 204 {
                        completion(error: nil, result: [204, ""])
                    }
                    else {
                        completion(error: nil, result: response.result.value)
                    }
                }
                else {
                    completion(error: nil, result: "Unexpected result")
                }
        }
    }
    
}