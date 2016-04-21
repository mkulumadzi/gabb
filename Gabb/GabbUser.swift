//
//  GabbUser.swift
//  Gabb
//
//  Created by Evan Waters on 4/17/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit
import SwiftyJSON

class GabbUser: NSObject {
    
    var email:String!
    var givenName:String!
    var familyName:String!
    
    init(email: String?, givenName:String?, familyName:String?) {
        if let email = email {
            self.email = email
        }
        if let givenName = givenName {
            self.givenName = givenName
        }
        if let familyName = familyName {
            self.familyName = familyName
        }
    }
    
    class func initWithDictionary(json: JSON) -> GabbUser {
        return GabbUser(email: json["email"].stringValue, givenName: json["given_name"].stringValue, familyName: json["family_name"].stringValue)
    }
    
    func fullName() -> String {
        if !self.givenName.isEmpty && !self.familyName.isEmpty {
            return "\(self.givenName) \(self.familyName)"
        }
        else if !self.givenName.isEmpty {
            return self.givenName
        }
        else if !self.familyName.isEmpty {
            return self.familyName
        }
        else {
            return ""
        }
    }

}
