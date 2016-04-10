//
//  Images.swift
//  Gabb
//
//  Created by Evan Waters on 4/10/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    /*
     Adapted solution from http://stackoverflow.com/questions/25146557/how-do-i-get-the-color-of-a-pixel-in-a-uiimage-with-swift
    */
    
    func getPixelColor(pos: CGPoint) -> UIColor {
        
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage))
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }  
}