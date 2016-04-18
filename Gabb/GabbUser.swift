//
//  GabbUser.swift
//  Gabb
//
//  Created by Evan Waters on 4/17/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit

class GabbUser: NSObject {
    
    var email:String!
    
    init(email: String?) {
        if let email = email {
            self.email = email
        }
    }

}
