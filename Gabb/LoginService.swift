//
//  LoginService.swift
//  Gabb
//
//  Created by Evan Waters on 4/18/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import JWTDecode

let MyKeychainWrapper = KeychainWrapper()

class LoginService {
    
    class func getTokenFromKeychain() -> String? {
        if MyKeychainWrapper.myObjectForKey(kSecAttrService) as? String == "postoffice" {
            if let token = MyKeychainWrapper.myObjectForKey("v_Data") as? String {
                var jwt:JWT!
                do {
                    jwt = try decode(token)
                } catch _ {
                    print("Could not decode token")
                }
                if jwt!.expired == false {
                    return token
                }
            }
        }
        return nil
    }
    
    class func saveLoginToUserDefaults(userToken: String) {
        MyKeychainWrapper.mySetObject(userToken, forKey:kSecValueData)
        MyKeychainWrapper.mySetObject("postoffice", forKey:kSecAttrService)
        MyKeychainWrapper.writeToKeychain()
    }
    
    class func confirmTokenMatchesValidUserOnServer(completion: (error: ErrorType?, result: AnyObject?) -> Void) {
        let userId = getUserIdFromToken()
        let token = getTokenFromKeychain()
        if let token = token {
            let headers:[String: String] = ["Authorization": "Bearer \(token)"]
            let url = "http://gabb.herokuapp.com/person/id/\(userId)"
            RestService.getRequest(url, headers: headers, completion: { error, result -> Void in
                if error != nil {
                    print("Token does not match valid user")
                    completion(error: error, result: nil)
                }
                else {
                    if let dictionary = result as? NSDictionary {
                        currentUser = GabbUser.initWithDictionary(JSON(dictionary))
                    }
                    completion(error: nil, result: "Success")
                }
            })
        }
    }
    
    class func getUserIdFromToken() -> String {
        let token = getTokenFromKeychain()!
        let payload = JSON(getTokenPayload(token)!)
        let userId = payload["id"].stringValue
        return userId
    }
    
    class func logIn(parameters: [String: String], completion: (error: ErrorType?, result: AnyObject?) -> Void) {
        print(parameters)
        
        Alamofire.request(.POST, "http://gabb.herokuapp.com/login", parameters: parameters, encoding: .JSON)
            .responseJSON { (response) in
                switch response.result {
                case .Success (let result):
                    let json = JSON(result)
                    
                    let personDictionary = json["person"]
                    currentUser = GabbUser.initWithDictionary(personDictionary)
                    
                    let token = json["access_token"].stringValue
                    saveLoginToUserDefaults(token)
                    
                    completion(error: nil, result: "Success")
                case .Failure(let error):
                    if response.response != nil {
                        completion(error: nil, result: "Invalid login")
                    }
                    else {
                        completion(error: error, result: nil)
                    }
                }
        }
        
    }
    
    class func getTokenPayload(token: String) -> [String: AnyObject]? {
        var payload:[String: AnyObject]!
        var jwt:JWT!
        do {
            jwt = try decode(token)
        } catch _ {
            print("Could not decode token")
        }
        if jwt != nil {
            payload = jwt!.body
        }
        return payload
    }
    
    class func logOut() {
        // Clear the keychain
        MyKeychainWrapper.mySetObject("", forKey:kSecValueData)
        MyKeychainWrapper.mySetObject("", forKey:kSecAttrService)
        MyKeychainWrapper.writeToKeychain()
        currentUser = nil
    }
    
    class func checkFieldAvailability(params: [String: String], completion: (error: ErrorType?, result: JSON?) -> Void) {
        let key:String = Array(params.keys)[0]
        let value:String = params[key]!
        
        let availableURL = "http://gabb.herokuapp.com/available?\(key)=\(value)"
        
        RestService.getRequest(availableURL, headers: nil, completion: { (error, result) -> Void in
            if error != nil {
                completion(error: error, result: nil)
            }
            else {
                let json = JSON(result!)
                completion(error: nil, result: json)
            }
        })
    }
    
}