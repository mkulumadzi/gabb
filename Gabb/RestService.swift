//
//  RestService.swift
//  Gabb
//
//  Created by Evan Waters on 3/26/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class RestService {
    
    class func getRequest(requestURL:String, headers: [String: String]?, completion: (error: ErrorType?, result: AnyObject?) -> Void) {
        
        Alamofire.request(.GET, requestURL, headers: headers)
            .responseJSON { (response) in
                switch response.result {
                case .Success (let result):
                    completion(error: nil, result: result)
                case .Failure(let error):
                    print(error)
                    if let statusCode = response.response?.statusCode {
                        completion(error: error, result: statusCode)
                    }
                    else {
                        completion(error: error, result: nil)
                    }
                }
        }
    }
    
    class func downloadImage(imageURL:String, completion: (result: UIImage?) -> Void) {
        Alamofire.request(.GET, imageURL)
            .responseImage { response in
                if let image = response.result.value {
                    completion(result: image)
                }
                else {
                    completion(result: nil)
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