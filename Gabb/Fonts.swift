//
//  Fonts.swift
//  Gabb
//
//  Created by Evan Waters on 3/25/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    class func logoLarge() -> UIFont? {
        if let font = UIFont(name: "AmaticSC-Regular", size: 64.0) {
            return font
        }
        else {
            return UIFont.systemFontOfSize(64.0)
        }
    }
    
}