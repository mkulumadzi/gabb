//
//  Strings.swift
//  Gabb
//
//  Created by Evan Waters on 4/9/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import Foundation

extension String {
    
    func toHash() -> String {
        var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
        if let data = self.dataUsingEncoding(NSUTF8StringEncoding) {
            CC_MD5(data.bytes, CC_LONG(data.length), &digest)
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
    
    func toHashWithExtension() -> String {
        var hash = self.toHash()
        let strArray = self.characters.split{$0 == "."}.map(String.init)
        if let ext = strArray.last {
            hash = hash + "." + ext
        }
        return hash
    }
    
}